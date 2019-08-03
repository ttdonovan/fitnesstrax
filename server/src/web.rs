#[macro_use]
extern crate serde_json;

extern crate chrono;
extern crate dimensioned;
extern crate emseries;
extern crate iron;
extern crate iron_cors;
extern crate micrologger;
extern crate orizentic;
extern crate params;
extern crate router;
extern crate serde;

extern crate fitnesstrax;

//use iron_cors::CorsMiddleware;
use serde_json::Value;
use std::collections::HashMap;
use std::env;

use fitnesstrax::{start_server, Configuration};

fn usage() {
    println!(
        "Fitnesstrax server

    environment variables:

        HOST -- (\"localhost\") the hostname of the server
        PORT -- (4001) the port to which to bind
        WEBAPP_PATH -- path to the index and static asset directory
        AUTHDB -- path to the authentication database file
        AUTHDB_SECRET -- the secret for validating authentication tokens
        TIME_DISTANCE -- (optional) the path to the time-distance database
        WEIGHT -- (optional) the path to the weight database
"
    );
}

fn main() {
    for arg in env::args() {
        if arg == "-h" {
            usage();
            return;
        }
    }

    let config = Configuration::load_from_environment();
    println!("Config: {:?}", config);

    let logger = micrologger::Logger::new(micrologger::json_stdout, &config.host, "fitnesstrax");

    let mut msg: HashMap<String, Value> = HashMap::new();
    msg.insert(String::from("msg"), json!("Starting Up"));
    logger.log("status", msg);

    let trax = fitnesstrax::Trax::new(fitnesstrax::Params {
        series_path: config.series_path.clone(),
    })
    .unwrap();

    let claimset = orizentic::filedb::load_claims_from_file(&String::from(
        config.authdb_path.to_str().unwrap(),
    ))
    .expect("should open the claims db");
    let orizentic_ctx = orizentic::OrizenticCtx::new(
        orizentic::Secret(config.authdb_secret.clone().into_bytes()),
        claimset,
    );
    println!("Starting server at http://{}:{}/", config.host, config.port);
    start_server(config, trax, orizentic_ctx);
}
