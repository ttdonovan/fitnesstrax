extern crate chrono;
extern crate dimensioned;
extern crate emseries;
extern crate iron;
extern crate iron_cors;
extern crate orizentic;
extern crate params;
extern crate router;
extern crate serde;
extern crate serde_json;

extern crate fitnesstrax;

use chrono::prelude::*;
use dimensioned::si::{KG, M, S};
use iron::headers::{Authorization, Bearer};
use iron::middleware::{BeforeMiddleware, Handler};
use iron::prelude::*;
use iron::status;
//use iron_cors::CorsMiddleware;
use router::Router;
use std::env;
use std::fmt;
use std::error;
use std::result;
use std::path;
use std::sync::{Arc, RwLock};

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
    RuntimeError(fitnesstrax::Error),
}

impl From<fitnesstrax::Error> for Error {
    fn from(error: fitnesstrax::Error) -> Self {
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


struct Configuration {
    host: String,
    port: i32,
    authdb_path: path::PathBuf,
    authdb_secret: String,
    time_distance_path: Option<path::PathBuf>,
    weight_path: Option<path::PathBuf>,
}

impl Configuration {
    fn load_from_environment() -> Configuration {
        fn make_optional(err: env::VarError) -> result::Result<Option<String>, env::VarError> {
            match err {
                env::VarError::NotPresent => Ok(None),
                err => Err(err)
            }
        }
        fn optional_var(name: &str) -> result::Result<Option<String>, env::VarError> {
            env::var(name).map(|v| Some(v)).or_else(make_optional)
        }

        let host = optional_var("HOST").expect("HOST should be absent or valid");
        let port = optional_var("PORT").expect("PORT should be absent or valid");
        let authdb_path = env::var("AUTHDB").expect("AUTHDB to be specified");
        let authdb_secret = env::var("AUTHDB_SECRET").expect("AUTHDB_SECRET to be specified");
        let time_distance_path = optional_var("TIME_DISTANCE").expect("TIME_DISTANCE should be absent or valid");
        let weight_path = optional_var("WEIGHT").expect("WEIGHT should be absent or valid");

        Configuration{
            host: host.unwrap_or(String::from("localhost")),
            port: port.and_then(|v| v.parse::<i32>().ok()).unwrap_or(4001),
            authdb_path: path::PathBuf::from(authdb_path),
            authdb_secret: String::from(authdb_secret),
            time_distance_path: time_distance_path.map(|p| path::PathBuf::from(p)),
            weight_path: weight_path.map(|p| path::PathBuf::from(p)),
        }
    }
}


fn auth_check(rn: &orizentic::ResourceName, perms: &orizentic::Permissions) -> bool {
    let orizentic::ResourceName(ref name) = rn;
    if name != "health" { return false; }
    let orizentic::Permissions(ref perm_vec) = perms;
    if perm_vec.contains(&String::from("read")) && perm_vec.contains(&String::from("write")) { return true; }
    return false;
}

struct AuthMiddleware {
    ctx: orizentic::OrizenticCtx,
}

impl BeforeMiddleware for AuthMiddleware {
    fn before(&self, req: &mut Request) -> IronResult<()> {
        let auth_str = req.headers.get::<Authorization<Bearer>>();
        match auth_str {
            Some(Authorization(bearer)) => {
                match self.ctx.decode_and_validate_text(&bearer.token) {
                    Ok(token) => {
                        println!("Authentication token: {:?}", token);
                        if token.check_authorizations(auth_check) {
                            Ok(())
                        } else {
                            Err(IronError::new(Error::NotAuthorized, status::Unauthorized))
                        }
                    }
                    Err(err) => Err(IronError::new(err, status::Unauthorized)),
                }
            }
            _ => Err(IronError::new(Error::BadParameter, status::BadRequest)),
        }
    }
}

fn date_param(params: &params::Map, field_name: &str) -> Result<Option<DateTime<Utc>>> {
    match params.find(&[field_name]) {
        Some(&params::Value::String(ref d_str)) => {
            DateTime::parse_from_rfc3339(d_str)
                .map(|val| Some(val.with_timezone(&Utc)))
                .map_err(|_err| Error::BadParameter)
        }
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
        Some(&params::Value::String(ref w_str)) => {
            w_str.parse::<f64>().map(|val| Some(val)).map_err(|_err| {
                Error::BadParameter
            })
        }
        Some(&params::Value::F64(ref val)) => Ok(Some(val.clone())),
        Some(_) => Err(Error::BadParameter),
        None => Ok(None),
    }
}

fn time_distance_activity_param(
    params: &params::Map,
    field_name: &str,
) -> Result<Option<fitnesstrax::ActivityType>> {
    match params.find(&[field_name]) {
        Some(&params::Value::String(ref s)) => {
            match s.as_str() {
                "Cycling" => Ok(Some(fitnesstrax::ActivityType::Cycling)),
                "Running" => Ok(Some(fitnesstrax::ActivityType::Running)),
                _ => Err(Error::BadParameter),
            }
        }
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
        Ok(r) => Ok(Response::with(
            (status::Ok, serde_json::to_string(&r).unwrap()),
        )),
        Err(Error::NotFound) => Ok(Response::with((status::NotFound, ""))),
        Err(err) => Err(IronError::new(err, status::BadRequest)),
    }
}

struct GetHandler {
    app: Arc<RwLock<fitnesstrax::App>>,
    type_: RecordType,
}
impl Handler for GetHandler {
    fn handle(&self, req: &mut Request) -> IronResult<Response> {
        let run = || {
            let capture = req.extensions.get::<Router>().unwrap().clone();

            let uuid = emseries::UniqueId::from_str(capture.find("uuid").unwrap())
                .map_err(|_| Error::BadParameter)?;
            let unique_id = match self.type_ {
                RecordType::WeightRecord => fitnesstrax::RecordId::WeightRecordId(uuid),
                RecordType::TimeDistanceRecord => fitnesstrax::RecordId::TimeDistanceRecordId(uuid),
            };

            match (*self.app).read().unwrap().get_record(&unique_id) {
                Ok(Some(record)) => Ok(record),
                Ok(None) => Err(Error::NotFound),
                Err(fitnesstrax::Error::NoSeries) => Err(Error::NotFound),
                err => panic!(format!("request failed {:?}", err)),
            }
        };
        app_to_iron(run())
    }
}

struct SaveWeightHandler {
    app: Arc<RwLock<fitnesstrax::App>>,
}
impl Handler for SaveWeightHandler {
    fn handle(&self, req: &mut Request) -> IronResult<Response> {
        let mut run = || {
            let capture = req.extensions.get::<Router>().unwrap().clone();
            let params = req.get_ref::<params::Params>().unwrap().clone();

            let uuid = invert_option_result(capture.find("uuid").map(
                |s| emseries::UniqueId::from_str(s),
            )).map_err(|_| Error::BadParameter)?;

            let date = date_param(&params, "date").map_err(|_| Error::BadParameter)?;
            let weight: Option<fitnesstrax::Weight> = f64_param(&params, "weight")
                .map(|m_val| m_val.map(|val| fitnesstrax::Weight::new(val * KG)))
                .map_err(|_| Error::BadParameter)?;

            match (uuid, date, weight) {
                (Some(uuid_), Some(date_), Some(weight_)) => {
                    self.app
                        .write()
                        .unwrap()
                        .replace_record(
                            fitnesstrax::RecordId::WeightRecordId(uuid_),
                            fitnesstrax::RecordType::WeightRecord(fitnesstrax::WeightRecord {
                                date: date_,
                                weight: weight_,
                            }),
                        )
                        .map_err(Error::from)
                }
                (None, Some(date_), Some(weight_)) => {
                    self.app
                        .write()
                        .unwrap()
                        .add_record(fitnesstrax::RecordType::WeightRecord(
                            fitnesstrax::WeightRecord {
                                date: date_,
                                weight: weight_,
                            },
                        ))
                        .map_err(Error::from)
                }
                _ => Err(Error::BadParameter),
            }
        };
        app_to_iron(run())
    }
}

struct SaveTimeDistanceHandler {
    app: Arc<RwLock<fitnesstrax::App>>,
}
impl Handler for SaveTimeDistanceHandler {
    fn handle(&self, req: &mut Request) -> IronResult<Response> {
        let mut run = || {
            let capture = req.extensions.get::<Router>().unwrap().clone();
            let params = req.get_ref::<params::Params>().unwrap().clone();

            let uuid = invert_option_result(capture.find("uuid").map(
                |s| emseries::UniqueId::from_str(s),
            )).map_err(|_| Error::BadParameter)?;

            let date = date_param(&params, "date").map_err(|_| Error::BadParameter)?;
            let distance = f64_param(&params, "distance").map(|m_val| {
                m_val.map(|val| val * M)
            })?;
            let activity = time_distance_activity_param(&params, "activity")?;
            let comments = string_param(&params, "comments")?;
            let duration = f64_param(&params, "duration").map(|m_val| {
                m_val.map(|val| val * S)
            })?;

            match (uuid, date, activity) {
                (Some(uuid_), Some(date_), Some(activity_)) => {
                    self.app
                        .write()
                        .unwrap()
                        .replace_record(
                            fitnesstrax::RecordId::TimeDistanceRecordId(uuid_),
                            fitnesstrax::RecordType::TimeDistanceRecord(
                                fitnesstrax::TimeDistanceRecord {
                                    timestamp: date_,
                                    activity: activity_,
                                    distance,
                                    duration,
                                    comments,
                                },
                            ),
                        )
                        .map_err(Error::from)
                }
                (None, Some(date_), Some(activity_)) => {
                    self.app
                        .write()
                        .unwrap()
                        .add_record(fitnesstrax::RecordType::TimeDistanceRecord(
                            fitnesstrax::TimeDistanceRecord {
                                timestamp: date_,
                                activity: activity_,
                                distance,
                                duration,
                                comments,
                            },
                        ))
                        .map_err(Error::from)
                }
                _ => Err(Error::BadParameter),
            }
        };
        app_to_iron(run())
    }
}

struct DeleteHandler {
    app: Arc<RwLock<fitnesstrax::App>>,
    type_: RecordType,
}
impl Handler for DeleteHandler {
    fn handle(&self, req: &mut Request) -> IronResult<Response> {
        let capture = req.extensions.get::<Router>().unwrap().clone();

        let uuid = invert_option_result(capture.find("uuid").map(
            |s| emseries::UniqueId::from_str(s),
        )).map_err(|err| IronError::new(err, status::BadRequest))?;

        match uuid {
            Some(uuid_) => {
                match self.type_ {
                    RecordType::WeightRecord => {
                        self.app.write().unwrap().remove_record(
                            &fitnesstrax::RecordId::WeightRecordId(uuid_),
                        )
                    }
                    RecordType::TimeDistanceRecord => {
                        self.app.write().unwrap().remove_record(
                            &fitnesstrax::RecordId::TimeDistanceRecordId(uuid_),
                        )
                    }
                }.map(|_r| Response::with((status::Ok, "")))
                    .map_err(|err| IronError::new(err, status::BadRequest))
            }
            None => Ok(Response::with((status::NotFound, ""))),
        }
    }
}

fn router(app_rc: Arc<RwLock<fitnesstrax::App>>, orizentic_ctx: orizentic::OrizenticCtx) -> Chain {
    let mut router = Router::new();
    // router.get("/", handler, "index");

    router.get(
        "/api/weight/:uuid",
        GetHandler {
            app: app_rc.clone(),
            type_: RecordType::WeightRecord,
        },
        "get_weight",
    );
    router.put(
        "/api/weight/",
        SaveWeightHandler { app: app_rc.clone() },
        "put_weight",
    );
    router.post(
        "/api/weight/:uuid",
        SaveWeightHandler { app: app_rc.clone() },
        "post_weight",
    );
    router.delete(
        "/api/weight/:uuid",
        DeleteHandler {
            app: app_rc.clone(),
            type_: RecordType::WeightRecord,
        },
        "delete_weight",
    );

    router.get(
        "/api/time_distance/:uuid",
        GetHandler {
            app: app_rc.clone(),
            type_: RecordType::TimeDistanceRecord,
        },
        "get_time_distance",
    );
    router.put(
        "/api/time_distance/",
        SaveTimeDistanceHandler { app: app_rc.clone() },
        "put_time_distance",
    );
    router.post(
        "/api/time_distance/:uuid",
        SaveTimeDistanceHandler { app: app_rc.clone() },
        "post_time_distance",
    );
    router.delete(
        "/api/time_distance/:uuid",
        DeleteHandler {
            app: app_rc.clone(),
            type_: RecordType::TimeDistanceRecord,
        },
        "delete_time_distance",
    );

    let mut chain = Chain::new(router);
    chain.link_before(AuthMiddleware { ctx: orizentic_ctx });
    chain
}

fn usage() {
    println!("Fitnesstrax server

    environment variables:

        HOST -- (\"localhost\") the hostname of the server
        PORT -- (4001) the port to which to bind
        AUTHDB -- path to the authentication database file
        AUTHDB_SECRET -- the secret for validating authentication tokens
        TIME_DISTANCE -- (optional) the path to the time-distance database
        WEIGHT -- (optional) the path to the weight database
");
}

fn main() {
    for arg in env::args() {
        if arg == "-h" {
            usage();
            return;
        }
    }

    let config = Configuration::load_from_environment();

    let app_rc = Arc::new(RwLock::new(
        fitnesstrax::App::new(fitnesstrax::Params {
            time_distance_path: config.time_distance_path,
            weight_path: config.weight_path,
        }).unwrap(),
    ));

    let claimset = orizentic::filedb::load_claims_from_file(&String::from(config.authdb_path.to_str().unwrap()))
        .expect("should open the claims db");
    let orizentic_ctx = orizentic::OrizenticCtx::new(
        orizentic::Secret(config.authdb_secret.into_bytes()),
        claimset,
    );
    println!("Starting server at http://{}:{}/", config.host, config.port);
    Iron::new(router(app_rc, orizentic_ctx))
        .http(format!("{}:{}", config.host, config.port))
        .unwrap();
}
