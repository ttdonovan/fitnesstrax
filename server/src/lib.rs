extern crate chrono;
extern crate chrono_tz;
extern crate dimensioned;
extern crate emseries;
extern crate serde;
#[macro_use]
extern crate serde_json;

extern crate fitnesstrax;
mod middleware;
mod server;

pub use fitnesstrax::{Params, Result, Trax, TraxRecord};
pub use middleware::logging::LoggingMiddleware;
pub use middleware::staticfile::StaticHandler;
pub use server::{start_server, Configuration};
