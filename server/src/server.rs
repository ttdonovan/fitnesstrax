extern crate chrono;
extern crate chrono_tz;
extern crate dimensioned;
extern crate emseries;
extern crate iron;
extern crate iron_cors;
extern crate micrologger;
extern crate orizentic;
extern crate params;
extern crate router;
extern crate serde;
extern crate urlencoding;

//use self::chrono::*;
use self::iron::headers::{Authorization, Bearer};
use self::iron::middleware::{BeforeMiddleware, Handler};
use self::iron::prelude::*;
use self::iron::status;
use self::router::Router;
use self::urlencoding::decode;
use chrono_tz::Etc::UTC;
use emseries::DateTimeTz;
use std::env;
use std::error;
use std::fmt;
use std::io::Read;
use std::path;
use std::result;
use std::sync::{Arc, RwLock};

use fitnesstrax;
use middleware::logging;
use middleware::staticfile;

type Result<A> = result::Result<A, Error>;
#[derive(Debug)]
enum Error {
    BadParameter,
    IOError(std::io::Error),
    MissingParameter,
    NotAuthorized,
    NotFound,
    RuntimeError(fitnesstrax::Error),
    SerdeError(serde_json::error::Error),
    TimeParseError(chrono::ParseError),
    TimeSeriesError(emseries::Error),
}

impl From<fitnesstrax::Error> for Error {
    fn from(error: fitnesstrax::Error) -> Self {
        Error::RuntimeError(error)
    }
}

impl From<chrono::ParseError> for Error {
    fn from(error: chrono::ParseError) -> Self {
        Error::TimeParseError(error)
    }
}

impl From<emseries::Error> for Error {
    fn from(error: emseries::Error) -> Self {
        Error::TimeSeriesError(error)
    }
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Error::BadParameter => write!(f, "Bad Parameter"),
            Error::IOError(err) => write!(f, "IO Error in operation: {}", err),
            Error::MissingParameter => write!(f, "Required parameter is missing"),
            Error::NotAuthorized => write!(f, "Not Authorized"),
            Error::NotFound => write!(f, "Not Found"),
            Error::RuntimeError(err) => write!(f, "Runtime error: {}", err),
            Error::SerdeError(err) => write!(f, "Deserialization error: {}", err),
            Error::TimeParseError(err) => write!(f, "Time value did not parse: {}", err),
            Error::TimeSeriesError(err) => {
                write!(f, "Failure in the underlying time series: {}", err)
            }
        }
    }
}

impl error::Error for Error {
    fn description(&self) -> &str {
        match self {
            Error::BadParameter => "Bad Parameter",
            Error::IOError(_) => "IO Error",
            Error::MissingParameter => "Missing Parameter",
            Error::NotAuthorized => "Not Authorized",
            Error::NotFound => "Not Found",
            Error::RuntimeError(_) => "Runtime Error",
            Error::SerdeError(_) => "Deserialization Error",
            Error::TimeParseError(_) => "Time parse error",
            Error::TimeSeriesError(_) => "Time series error",
        }
    }

    fn cause(&self) -> Option<&error::Error> {
        match self {
            Error::BadParameter => None,
            Error::IOError(ref err) => Some(err),
            Error::MissingParameter => None,
            Error::NotAuthorized => None,
            Error::NotFound => None,
            Error::RuntimeError(ref err) => Some(err),
            Error::SerdeError(ref err) => Some(err),
            Error::TimeParseError(ref err) => Some(err),
            Error::TimeSeriesError(ref err) => Some(err),
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

enum RecordType {
    Comments,
    RepDuration,
    SetRep,
    Steps,
    TimeDistance,
    Weight,
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
    app: Arc<RwLock<fitnesstrax::Trax>>,
}
impl Handler for GetHandler {
    fn handle(&self, req: &mut Request) -> IronResult<Response> {
        let run = || {
            let capture = req.extensions.get::<Router>().unwrap().clone();

            let uuid = match capture.find("uuid").map(emseries::UniqueId::from_str) {
                Some(Ok(uuid)) => Ok(uuid),
                Some(Err(_)) => Err(Error::BadParameter),
                None => Err(Error::BadParameter),
            }?;

            match (*self.app).read().unwrap().get_record(&uuid) {
                Ok(Some(record)) => Ok(record),
                Ok(None) => Err(Error::NotFound),
                Err(fitnesstrax::Error::NoSeries) => Err(Error::NotFound),
                err => panic!(format!("request failed {:?}", err)),
            }
        };
        app_to_iron(run())
    }
}

struct NewRecordHandler {
    app: Arc<RwLock<fitnesstrax::Trax>>,
    type_: RecordType,
}
impl Handler for NewRecordHandler {
    fn handle(&self, req: &mut Request) -> IronResult<Response> {
        let mut run =
            || {
                let mut body: Vec<u8> = Vec::new();
                req.body.read_to_end(&mut body).map_err(Error::IOError)?;
                let record_result =
                    match self.type_ {
                        RecordType::Comments => serde_json::from_slice(&body)
                            .map(|v| fitnesstrax::TraxRecord::Comments(v)),
                        RecordType::RepDuration => serde_json::from_slice(&body)
                            .map(|v| fitnesstrax::TraxRecord::RepDuration(v)),
                        RecordType::SetRep => serde_json::from_slice(&body)
                            .map(|v| fitnesstrax::TraxRecord::SetRep(v)),
                        RecordType::Steps => {
                            serde_json::from_slice(&body).map(|v| fitnesstrax::TraxRecord::Steps(v))
                        }
                        RecordType::TimeDistance => serde_json::from_slice(&body)
                            .map(|v| fitnesstrax::TraxRecord::TimeDistance(v)),
                        RecordType::Weight => serde_json::from_slice(&body)
                            .map(|v| fitnesstrax::TraxRecord::Weight(v)),
                    };
                match record_result {
                    Ok(rec) => self
                        .app
                        .write()
                        .unwrap()
                        .add_record(rec)
                        .map_err(Error::from),
                    Err(err) => Err(Error::SerdeError(err)),
                }
            };

        app_to_iron(run())
    }
}

struct UpdateRecordHandler {
    app: Arc<RwLock<fitnesstrax::Trax>>,
}
impl Handler for UpdateRecordHandler {
    fn handle(&self, req: &mut Request) -> IronResult<Response> {
        let capture = req.extensions.get::<Router>().unwrap().clone();

        let mut run = || {
            let uuid = match capture.find("uuid").map(emseries::UniqueId::from_str) {
                Some(Ok(uuid)) => Ok(uuid),
                Some(Err(_)) => Err(Error::BadParameter),
                None => Err(Error::BadParameter),
            }?;

            let mut body: Vec<u8> = Vec::new();
            req.body.read_to_end(&mut body).map_err(Error::IOError)?;
            let record = serde_json::from_slice(&body).map_err(Error::SerdeError)?;
            self.app
                .write()
                .unwrap()
                .replace_record(uuid, record)
                .map_err(Error::from)
        };

        app_to_iron(run())
    }
}

struct DeleteHandler {
    app: Arc<RwLock<fitnesstrax::Trax>>,
}
impl Handler for DeleteHandler {
    fn handle(&self, req: &mut Request) -> IronResult<Response> {
        let capture = req.extensions.get::<Router>().unwrap().clone();

        let uuid = capture
            .find("uuid")
            .map(|s| emseries::UniqueId::from_str(s))
            .transpose()
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

struct GetHistoryHandler {
    app: Arc<RwLock<fitnesstrax::Trax>>,
}
impl Handler for GetHistoryHandler {
    fn handle(&self, req: &mut Request) -> IronResult<Response> {
        let run = || {
            let capture = req.extensions.get::<Router>().unwrap().clone();

            let start_date = capture
                .find("start")
                .ok_or(Error::MissingParameter)
                .and_then(|s| {
                    DateTimeTz::from_str(&decode(s).unwrap())
                        .map(|dtz| DateTimeTz(dtz.0.with_timezone(&UTC)))
                        .map_err(Error::from)
                })?;

            let end_date = capture
                .find("end")
                .ok_or(Error::MissingParameter)
                .and_then(|s| {
                    DateTimeTz::from_str(&decode(s).unwrap())
                        .map(|dtz| DateTimeTz(dtz.0.with_timezone(&UTC)))
                        .map_err(Error::from)
                })?;

            self.app
                .read()
                .unwrap()
                .get_history(start_date, end_date)
                .map_err(Error::from)
        };

        app_to_iron(run())
    }
}

fn api_routes(app_rc: Arc<RwLock<fitnesstrax::Trax>>) -> Router {
    let mut router = Router::new();

    router.get(
        "/api/record/:uuid",
        GetHandler {
            app: app_rc.clone(),
        },
        "get_record",
    );
    router.put(
        "/api/record/comments",
        NewRecordHandler {
            app: app_rc.clone(),
            type_: RecordType::Comments,
        },
        "put_comment_record",
    );
    router.put(
        "/api/record/repduration",
        NewRecordHandler {
            app: app_rc.clone(),
            type_: RecordType::RepDuration,
        },
        "put_repduration_record",
    );
    router.put(
        "/api/record/setrep",
        NewRecordHandler {
            app: app_rc.clone(),
            type_: RecordType::SetRep,
        },
        "put_setrep_record",
    );
    router.put(
        "/api/record/steps",
        NewRecordHandler {
            app: app_rc.clone(),
            type_: RecordType::Steps,
        },
        "put_step_record",
    );
    router.put(
        "/api/record/timedistance",
        NewRecordHandler {
            app: app_rc.clone(),
            type_: RecordType::TimeDistance,
        },
        "put_timedistance_record",
    );
    router.put(
        "/api/record/weight",
        NewRecordHandler {
            app: app_rc.clone(),
            type_: RecordType::Weight,
        },
        "put_weight_record",
    );
    router.post(
        "/api/record/:uuid",
        UpdateRecordHandler {
            app: app_rc.clone(),
        },
        "update_record",
    );
    router.delete(
        "/api/record/:uuid",
        DeleteHandler {
            app: app_rc.clone(),
        },
        "delete_record",
    );

    router.get(
        "/api/history/all/:start/:end",
        GetHistoryHandler {
            app: app_rc.clone(),
        },
        "get_history_all",
    );

    router
}

fn routes(
    host: &str,
    static_asset_path: &path::PathBuf,
    app_name: &str,
    app_rc: Arc<RwLock<fitnesstrax::Trax>>,
    orizentic_ctx: Arc<orizentic::OrizenticCtx>,
) -> Chain {
    let mut router = Router::new();

    let mut api_chain = Chain::new(api_routes(app_rc));
    api_chain.link_before(AuthMiddleware { ctx: orizentic_ctx });
    //println!("{}", base.format("YYYY-MM-DD"));
    router.any("/api/*", api_chain, "api_routes");

    let mut bundle_path = static_asset_path.clone();
    bundle_path.push("bundle.js");
    let mut index_path = static_asset_path.clone();
    index_path.push("index.html");
    let mut calendar_path = static_asset_path.clone();
    calendar_path.push("icons8-calendar-24.png");

    router.get(
        "/static/bundle.js",
        staticfile::StaticHandler::file(bundle_path, "application/javascript".parse().unwrap()),
        "webapp",
    );
    router.get(
        "/static/calendar_icon.png",
        staticfile::StaticHandler::file(calendar_path, "image/png".parse().unwrap()),
        "calendar_icon",
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
    trax: fitnesstrax::Trax,
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
