extern crate chrono;
extern crate dimensioned;
extern crate emseries;
extern crate iron;
extern crate iron_cors;
extern crate micrologger;
extern crate mount;
extern crate orizentic;
extern crate params;
extern crate router;
extern crate serde;

use self::iron::headers::{Authorization, Bearer};
use self::iron::middleware::{BeforeMiddleware, Handler};
use self::iron::prelude::*;
use self::iron::status;
use chrono::prelude::*;
use dimensioned::si::{KG, M, S};
//use iron_cors::CorsMiddleware;
use self::router::Router;
use std::env;
use std::error;
use std::fmt;
use std::path;
use std::result;
use std::sync::{Arc, RwLock};

use core;
use logging;
use staticfile;
use types;

fn invert_option_result<A, B>(val: Option<result::Result<A, B>>) -> result::Result<Option<A>, B> {
    match val {
        None => Ok(None),
        Some(Ok(v)) => Ok(Some(v)),
        Some(Err(err)) => Err(err),
    }
}

type Result<A> = result::Result<A, Error>;
#[derive(Debug)]
enum Error {
    BadParameter,
    NotAuthorized,
    NotFound,
    RuntimeError(core::Error),
}

impl From<core::Error> for Error {
    fn from(error: core::Error) -> Self {
        Error::RuntimeError(error)
    }
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Error::BadParameter => write!(f, "Bad Parameter"),
            Error::NotAuthorized => write!(f, "Not Authorized"),
            Error::NotFound => write!(f, "Not Found"),
            Error::RuntimeError(err) => write!(f, "Runtime error: {}", err),
        }
    }
}

impl error::Error for Error {
    fn description(&self) -> &str {
        match self {
            Error::BadParameter => "Bad Parameter",
            Error::NotAuthorized => "Not Authorized",
            Error::NotFound => "Not Found",
            Error::RuntimeError(_) => "Runtime Error",
        }
    }

    fn cause(&self) -> Option<&error::Error> {
        match self {
            Error::BadParameter => None,
            Error::NotAuthorized => None,
            Error::NotFound => None,
            Error::RuntimeError(ref err) => Some(err),
        }
    }
}

#[derive(Debug)]
pub struct Configuration {
    pub host: String,
    pub port: i32,
    pub webapp_path: path::PathBuf,
    pub authdb_path: path::PathBuf,
    pub authdb_secret: String,
    pub series_path: path::PathBuf,
}

impl Configuration {
    pub fn load_from_environment() -> Configuration {
        fn make_optional(err: env::VarError) -> result::Result<Option<String>, env::VarError> {
            match err {
                env::VarError::NotPresent => Ok(None),
                err => Err(err),
            }
        }
        fn optional_var(name: &str) -> result::Result<Option<String>, env::VarError> {
            env::var(name).map(|v| Some(v)).or_else(make_optional)
        }

        let host = optional_var("HOST").expect("HOST should be absent or valid");
        let port = optional_var("PORT").expect("PORT should be absent or valid");
        let webapp_path = env::var("WEBAPP_PATH").expect("WEBAPP_PATH to be specified");
        let authdb_path = env::var("AUTHDB").expect("AUTHDB to be specified");
        let authdb_secret = env::var("AUTHDB_SECRET").expect("AUTHDB_SECRET to be specified");
        let series_path = env::var("SERIES_PATH").expect("SERIES_PATH to be specified");

        Configuration {
            host: host.unwrap_or(String::from("localhost")),
            port: port.and_then(|v| v.parse::<i32>().ok()).unwrap_or(4001),
            webapp_path: path::PathBuf::from(webapp_path),
            authdb_path: path::PathBuf::from(authdb_path),
            authdb_secret: String::from(authdb_secret),
            series_path: path::PathBuf::from(series_path),
        }
    }
}

fn auth_check(rn: &orizentic::ResourceName, perms: &orizentic::Permissions) -> bool {
    let orizentic::ResourceName(ref name) = rn;
    if name != "health" {
        return false;
    }
    let orizentic::Permissions(ref perm_vec) = perms;
    if perm_vec.contains(&String::from("read")) && perm_vec.contains(&String::from("write")) {
        return true;
    }
    return false;
}

struct AuthMiddleware {
    ctx: Arc<orizentic::OrizenticCtx>,
}

impl BeforeMiddleware for AuthMiddleware {
    fn before(&self, req: &mut Request) -> IronResult<()> {
        let auth_str = req.headers.get::<Authorization<Bearer>>();
        match auth_str {
            Some(Authorization(bearer)) => match self.ctx.decode_and_validate_text(&bearer.token) {
                Ok(token) => {
                    if token.check_authorizations(auth_check) {
                        Ok(())
                    } else {
                        Err(IronError::new(Error::NotAuthorized, status::Unauthorized))
                    }
                }
                Err(err) => Err(IronError::new(err, status::Unauthorized)),
            },
            None => Err(IronError::new(Error::NotAuthorized, status::Unauthorized)),
        }
    }
}

fn date_param(params: &params::Map, field_name: &str) -> Result<Option<DateTime<Utc>>> {
    match params.find(&[field_name]) {
        Some(&params::Value::String(ref d_str)) => DateTime::parse_from_rfc3339(d_str)
            .map(|val| Some(val.with_timezone(&Utc)))
            .map_err(|_err| Error::BadParameter),
        Some(_) => Err(Error::BadParameter),
        None => Ok(None),
    }
}

fn string_param(params: &params::Map, field_name: &str) -> Result<Option<String>> {
    match params.find(&[field_name]) {
        Some(&params::Value::String(ref w_str)) => Ok(Some(w_str.clone())),
        Some(_) => Err(Error::BadParameter),
        None => Ok(None),
    }
}

fn f64_param(params: &params::Map, field_name: &str) -> Result<Option<f64>> {
    match params.find(&[field_name]) {
        Some(&params::Value::String(ref w_str)) => w_str
            .parse::<f64>()
            .map(|val| Some(val))
            .map_err(|_err| Error::BadParameter),
        Some(&params::Value::F64(ref val)) => Ok(Some(val.clone())),
        Some(_) => Err(Error::BadParameter),
        None => Ok(None),
    }
}

fn time_distance_activity_param(
    params: &params::Map,
    field_name: &str,
) -> Result<Option<core::ActivityType>> {
    match params.find(&[field_name]) {
        Some(&params::Value::String(ref s)) => match s.as_str() {
            "Cycling" => Ok(Some(core::ActivityType::Cycling)),
            "Running" => Ok(Some(core::ActivityType::Running)),
            _ => Err(Error::BadParameter),
        },
        Some(_) => Err(Error::BadParameter),
        None => Ok(None),
    }
}

enum RecordType {
    WeightRecord,
    TimeDistanceRecord,
}

fn app_to_iron<A>(result: Result<A>) -> IronResult<Response>
where
    A: serde::Serialize,
{
    match result {
        Ok(r) => Ok(Response::with((
            status::Ok,
            serde_json::to_string(&r).unwrap(),
        ))),
        Err(Error::NotFound) => Ok(Response::with((status::NotFound, ""))),
        Err(err) => Err(IronError::new(err, status::BadRequest)),
    }
}

struct GetHandler {
    app: Arc<RwLock<core::App>>,
}
impl Handler for GetHandler {
    fn handle(&self, req: &mut Request) -> IronResult<Response> {
        let run = || {
            let capture = req.extensions.get::<Router>().unwrap().clone();

            let uuid = emseries::UniqueId::from_str(capture.find("uuid").unwrap())
                .map_err(|_| Error::BadParameter)?;

            match (*self.app).read().unwrap().get_record(&uuid) {
                Ok(Some(record)) => Ok(record),
                Ok(None) => Err(Error::NotFound),
                Err(core::Error::NoSeries) => Err(Error::NotFound),
                err => panic!(format!("request failed {:?}", err)),
            }
        };
        app_to_iron(run())
    }
}

struct SaveWeightHandler {
    app: Arc<RwLock<core::App>>,
}
impl Handler for SaveWeightHandler {
    fn handle(&self, req: &mut Request) -> IronResult<Response> {
        let mut run = || {
            let capture = req.extensions.get::<Router>().unwrap().clone();
            let params = req.get_ref::<params::Params>().unwrap().clone();

            let uuid = invert_option_result(
                capture
                    .find("uuid")
                    .map(|s| emseries::UniqueId::from_str(s)),
            )
            .map_err(|_| Error::BadParameter)?;

            let date = date_param(&params, "date").map_err(|_| Error::BadParameter)?;
            let weight: Option<types::Weight> = f64_param(&params, "weight")
                .map(|m_val| m_val.map(|val| types::Weight::new(val * KG)))
                .map_err(|_| Error::BadParameter)?;

            match (uuid, date, weight) {
                (Some(uuid_), Some(date_), Some(weight_)) => self
                    .app
                    .write()
                    .unwrap()
                    .replace_record(
                        uuid_,
                        core::RecordType::WeightRecord(types::WeightRecord {
                            date: date_,
                            weight: weight_,
                        }),
                    )
                    .map_err(Error::from),
                (None, Some(date_), Some(weight_)) => self
                    .app
                    .write()
                    .unwrap()
                    .add_record(core::RecordType::WeightRecord(types::WeightRecord {
                        date: date_,
                        weight: weight_,
                    }))
                    .map_err(Error::from),
                _ => Err(Error::BadParameter),
            }
        };
        app_to_iron(run())
    }
}

struct SaveTimeDistanceHandler {
    app: Arc<RwLock<core::App>>,
}
impl Handler for SaveTimeDistanceHandler {
    fn handle(&self, req: &mut Request) -> IronResult<Response> {
        let mut run = || {
            let capture = req.extensions.get::<Router>().unwrap().clone();
            let params = req.get_ref::<params::Params>().unwrap().clone();

            let uuid = invert_option_result(
                capture
                    .find("uuid")
                    .map(|s| emseries::UniqueId::from_str(s)),
            )
            .map_err(|_| Error::BadParameter)?;

            let date = date_param(&params, "date").map_err(|_| Error::BadParameter)?;
            let distance = f64_param(&params, "distance").map(|m_val| m_val.map(|val| val * M))?;
            let activity = time_distance_activity_param(&params, "activity")?;
            let comments = string_param(&params, "comments")?;
            let duration = f64_param(&params, "duration").map(|m_val| m_val.map(|val| val * S))?;

            match (uuid, date, activity) {
                (Some(uuid_), Some(date_), Some(activity_)) => self
                    .app
                    .write()
                    .unwrap()
                    .replace_record(
                        uuid_,
                        core::RecordType::TimeDistanceRecord(types::TimeDistanceRecord {
                            timestamp: date_,
                            activity: activity_,
                            distance,
                            duration,
                            comments,
                        }),
                    )
                    .map_err(Error::from),
                (None, Some(date_), Some(activity_)) => self
                    .app
                    .write()
                    .unwrap()
                    .add_record(core::RecordType::TimeDistanceRecord(
                        types::TimeDistanceRecord {
                            timestamp: date_,
                            activity: activity_,
                            distance,
                            duration,
                            comments,
                        },
                    ))
                    .map_err(Error::from),
                _ => Err(Error::BadParameter),
            }
        };
        app_to_iron(run())
    }
}

struct DeleteHandler {
    app: Arc<RwLock<core::App>>,
}
impl Handler for DeleteHandler {
    fn handle(&self, req: &mut Request) -> IronResult<Response> {
        let capture = req.extensions.get::<Router>().unwrap().clone();

        let uuid = invert_option_result(
            capture
                .find("uuid")
                .map(|s| emseries::UniqueId::from_str(s)),
        )
        .map_err(|err| IronError::new(err, status::BadRequest))?;

        match uuid {
            Some(uuid_) => self
                .app
                .write()
                .unwrap()
                .remove_record(&uuid_)
                .map(|_r| Response::with((status::Ok, "")))
                .map_err(|err| IronError::new(err, status::BadRequest)),
            None => Ok(Response::with((status::NotFound, ""))),
        }
    }
}

fn api_routes(app_rc: Arc<RwLock<core::App>>) -> Router {
    let mut router = Router::new();

    router.get(
        "/api/weight/:uuid",
        GetHandler {
            app: app_rc.clone(),
        },
        "get_weight",
    );
    router.put(
        "/api/weight/",
        SaveWeightHandler {
            app: app_rc.clone(),
        },
        "put_weight",
    );
    router.post(
        "/api/weight/:uuid",
        SaveWeightHandler {
            app: app_rc.clone(),
        },
        "post_weight",
    );
    router.delete(
        "/api/weight/:uuid",
        DeleteHandler {
            app: app_rc.clone(),
        },
        "delete_weight",
    );

    router.get(
        "/api/time_distance/:uuid",
        GetHandler {
            app: app_rc.clone(),
        },
        "get_time_distance",
    );
    router.put(
        "/api/time_distance/",
        SaveTimeDistanceHandler {
            app: app_rc.clone(),
        },
        "put_time_distance",
    );
    router.post(
        "/api/time_distance/:uuid",
        SaveTimeDistanceHandler {
            app: app_rc.clone(),
        },
        "post_time_distance",
    );
    router.delete(
        "/api/time_distance/:uuid",
        DeleteHandler {
            app: app_rc.clone(),
        },
        "delete_time_distance",
    );

    router
}

fn routes(
    host: &str,
    static_asset_path: &path::PathBuf,
    app_name: &str,
    app_rc: Arc<RwLock<core::App>>,
    orizentic_ctx: Arc<orizentic::OrizenticCtx>,
) -> Chain {
    let mut router = Router::new();

    let mut api_chain = Chain::new(api_routes(app_rc));
    api_chain.link_before(AuthMiddleware { ctx: orizentic_ctx });
    router.any("/api/*", api_chain, "api_routes");

    let mut bundle_path = static_asset_path.clone();
    bundle_path.push("dist/bundle.js");
    let mut index_path = static_asset_path.clone();
    index_path.push("index.html");

    router.get(
        "/static/bundle.js",
        staticfile::StaticHandler::file(bundle_path, "application/javascript".parse().unwrap()),
        "webapp",
    );
    router.get(
        "/",
        staticfile::StaticHandler::file(index_path, "text/html".parse().unwrap()),
        "index",
    );

    let mut chain = Chain::new(router);
    chain.link_before(logging::LoggingMiddleware::new(host, app_name));
    chain.link_after(logging::LoggingMiddleware::new(host, app_name));
    chain
}

pub fn start_server(
    config: Configuration,
    trax: core::App,
    orizentic_ctx: orizentic::OrizenticCtx,
) -> iron::Listening {
    let app_rc = Arc::new(RwLock::new(trax));
    let orizentic_rc = Arc::new(orizentic_ctx);

    Iron::new(routes(
        &config.host,
        &config.webapp_path,
        "fitnesstrax",
        app_rc,
        orizentic_rc,
    ))
    .http(format!("{}:{}", config.host, config.port))
    .unwrap()
}
