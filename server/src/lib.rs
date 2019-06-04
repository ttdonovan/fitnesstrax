extern crate chrono;
extern crate dimensioned;
extern crate emseries;
extern crate serde;
#[macro_use]
extern crate serde_derive;
#[macro_use]
extern crate serde_json;

mod middleware;
mod server;
mod trax;
mod utils;

pub use middleware::logging::LoggingMiddleware;
pub use middleware::staticfile::StaticHandler;
pub use server::{start_server, Configuration};
pub use trax::types::{ActivityType, TimeDistance, TimeDistanceRecord, Weight, WeightRecord};
pub use trax::{Params, Result, Trax, TraxRecord};
pub use utils::CleanupFile;
