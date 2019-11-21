extern crate chrono;
extern crate chrono_tz;
extern crate dimensioned;
extern crate emseries;
extern crate serde;

mod components;
mod types;

pub use components::day_c;
pub use types::*;

use chrono::TimeZone;
use emseries::DateTimeTz;
use futures::stream::Stream;
use futures::task::{Context, Poll};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::env;
use std::error;
use std::fmt;
use std::fs::File;
use std::io;
use std::path;
use std::result;
use std::sync::{Arc, RwLock};

#[derive(Debug)]
pub enum Error {
    TraxError(fitnesstrax::Error),
    IOError(io::Error),
}

impl From<fitnesstrax::Error> for Error {
    fn from(error: fitnesstrax::Error) -> Self {
        Error::TraxError(error)
    }
}

impl From<io::Error> for Error {
    fn from(error: io::Error) -> Self {
        Error::IOError(error)
    }
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Error::TraxError(err) => write!(f, "Trax encountered an error: {}", err),
            Error::IOError(err) => write!(f, "IO Error: {}", err),
        }
    }
}

impl error::Error for Error {
    fn description(&self) -> &str {
        match self {
            Error::TraxError(err) => err.description(),
            Error::IOError(err) => err.description(),
        }
    }

    fn cause(&self) -> Option<&(dyn error::Error + 'static)> {
        match self {
            Error::TraxError(ref err) => Some(err),
            Error::IOError(ref err) => Some(err),
        }
    }
}

type Result<A> = result::Result<A, Error>;

#[derive(Debug, Serialize, Deserialize)]
struct Configuration {
    series_path: path::PathBuf,
    timezone: chrono_tz::Tz,
    language: String,
}

impl Configuration {
    fn load_from_yaml() -> Configuration {
        let config_path = env::var("CONFIG").unwrap_or("config.yaml".to_string());
        let config_file = File::open(config_path.clone())
            .expect(&format!("cannot open configuration file: {}", &config_path));
        serde_yaml::from_reader(config_file).expect("invalid configuration file")
    }
}

type DateRange = Range<chrono::Date<chrono_tz::Tz>>;

/* Views for the application
 *
 * History -- needs the current query, possibly a cache of the data being displayed
 * Configuration -- just needs the current configuration
 * Graphs -- needs graphing parameters, possibly different parameters per graph. Potentially
 * multiple graphs.
 */

pub enum Messages {
    RangeUpdate {
        range: DateRange,
        records: Vec<emseries::Record<TraxRecord>>,
    },
}

pub struct AppContext {
    config: Arc<RwLock<Configuration>>,
    trax: Arc<RwLock<fitnesstrax::Trax>>,

    range: Arc<RwLock<DateRange>>,
}

impl<'obs> AppContext {
    pub fn new() -> Result<AppContext> {
        let config_ = Configuration::load_from_yaml();

        let trax = fitnesstrax::Trax::new(fitnesstrax::Params {
            series_path: config_.series_path.clone(),
        })
        .map(|t| Arc::new(RwLock::new(t)))?;

        let range = Arc::new(RwLock::new(Range::new(
            /*
            Utc::today().with_timezone(&config_.timezone) - chrono::Duration::days(7),
            Utc::today().with_timezone(&config_.timezone),
            */
            config_.timezone.ymd(2019, 9, 1),
            config_.timezone.ymd(2019, 9, 30),
        )));

        let config = Arc::new(RwLock::new(config_));
        Ok(AppContext {
            config,
            trax,
            range,
        })
    }

    pub fn get_timezone(&self) -> chrono_tz::Tz {
        self.config.read().unwrap().timezone.clone()
    }

    pub fn set_timezone(&self, timezone: chrono_tz::Tz) {
        self.config.write().unwrap().timezone = timezone;
    }

    pub fn get_language(&self) -> String {
        self.config.read().unwrap().language.clone()
    }

    pub fn set_language(&self, language: String) {
        self.config.write().unwrap().language = language;
    }

    pub fn get_range(&self) -> DateRange {
        (*self.range.read().unwrap()).clone()
    }

    pub fn set_range(&mut self, range: DateRange) {
        *self.range.write().unwrap() = range.clone();

        /*
        self.range_listeners
            .read()
            .unwrap()
            .iter()
            .for_each(|f| f(&range));
            */
    }

    /*
    pub fn get_history(
        &self,
        range_: Option<DateRange>,
    ) -> HashMap<chrono::Date<chrono_tz::Tz>, Vec<emseries::Record<TraxRecord>>> {
        let range = range_.unwrap_or_else(|| (*self.range.read().unwrap()).clone());
        let trax = self.trax.read().unwrap();

        group_by_date(
            range.clone(),
            trax.get_history(
                DateTimeTz(range.start.and_hms(0, 0, 0)),
                DateTimeTz(range.end.and_hms(0, 0, 0)),
            )
            .unwrap(),
        )
    }

    pub fn get_range_stream<F>(&mut self) -> Stream<Result<Async<Option<RangeUpdate>,  {
        self.range_listeners.write().unwrap().push(f);
    }
    */
}

/*
struct AppListener {}

impl Stream for AppListener {
    type Item = Messages;

    fn poll_next(&mut self, cx: &mut Context) -> Poll<Option<Self::Item>> {
        Poll::Ready(None);
    }
}
*/
