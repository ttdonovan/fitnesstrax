extern crate chrono;
extern crate dimensioned;
extern crate emseries;
extern crate serde;
extern crate serde_derive;
extern crate serde_json;

use chrono::prelude::*;
use std::error;
use std::fmt;
use std::path;
use std::result;

pub use logging::LoggingMiddleware;
pub use staticfile::StaticHandler;
pub use types::{ActivityType, TimeDistance, TimeDistanceRecord, Weight, WeightRecord};
pub use utils::CleanupFile;

#[derive(Debug)]
pub enum Error {
    NoSeries,
    SeriesError(emseries::Error),
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Error::NoSeries => write!(f, "Series is not open"),
            Error::SeriesError(err) => write!(f, "Series Error: {}", err),
        }
    }
}

impl error::Error for Error {
    fn description(&self) -> &str {
        match self {
            Error::NoSeries => "Series is not open",
            Error::SeriesError(err) => err.description(),
        }
    }

    fn cause(&self) -> Option<&error::Error> {
        match self {
            Error::NoSeries => None,
            Error::SeriesError(ref err) => Some(err),
        }
    }
}

pub type Result<A> = result::Result<A, Error>;

#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
pub enum RecordType {
    TimeDistanceRecord(TimeDistanceRecord),
    WeightRecord(WeightRecord),
}

impl emseries::Recordable for RecordType {
    fn timestamp(&self) -> DateTime<Utc> {
        match self {
            RecordType::TimeDistanceRecord(rec) => rec.timestamp(),
            RecordType::WeightRecord(rec) => rec.timestamp(),
        }
    }

    fn tags(&self) -> Vec<String> {
        match self {
            RecordType::TimeDistanceRecord(rec) => rec.tags(),
            RecordType::WeightRecord(rec) => rec.tags(),
        }
    }
}

#[derive(Clone, Debug)]
pub struct Params {
    pub series_path: path::PathBuf,
}

pub struct App {
    series: emseries::Series<RecordType>,
}

impl App {
    pub fn new(params: Params) -> Result<App> {
        let series = emseries::Series::open(params.series_path.to_str().unwrap())
            .map_err(|err| Error::SeriesError(err))?;

        Ok(App { series })
    }

    pub fn add_record(&mut self, record: RecordType) -> Result<emseries::UniqueId> {
        self.series
            .put(record)
            .map_err(|err| Error::SeriesError(err))
    }

    pub fn replace_record(
        &mut self,
        uid: emseries::UniqueId,
        record: RecordType,
    ) -> Result<emseries::UniqueId> {
        self.series
            .update(emseries::Record {
                id: uid.clone(),
                data: record,
            })
            .map_err(|err| Error::SeriesError(err))?;
        Ok(uid)
    }

    pub fn get_record(&self, uid: &emseries::UniqueId) -> Result<Option<RecordType>> {
        self.series
            .get(uid)
            .map(|mr| mr.map(|r| r.data))
            .map_err(|err| Error::SeriesError(err))
    }

    pub fn remove_record(&mut self, uid: &emseries::UniqueId) -> Result<()> {
        self.series
            .delete(uid)
            .map_err(|err| Error::SeriesError(err))
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use chrono::prelude::*;
    use dimensioned::si::{KG, M, S};
    use emseries::Record;
    use serde_json;

    fn standard_app() -> App {
        App::new(Params {
            series_path: path::PathBuf::from("var/series_test.series"),
        })
        .expect("the app to be created")
    }

    #[test]
    fn it_records_and_retrieves_a_new_weight() {
        let mut app = standard_app();

        let date = Utc::now();
        let record = WeightRecord {
            date,
            weight: Weight::new(85.0 * KG),
        };

        let uuid = app
            .add_record(RecordType::WeightRecord(record.clone()))
            .expect("did not create a record");
        let rec = app
            .get_record(&uuid)
            .expect("should be able to retrieve record");
        assert_eq!(rec, Some(RecordType::WeightRecord(record)));
    }

    #[test]
    fn it_records_and_retrieves_new_time_distance() {
        let mut app = standard_app();

        let date = Utc::now();
        let record = TimeDistance {
            timestamp: date,
            comments: Some(String::from("just some notes")),
            distance: Some(25.0 * M),
            duration: Some(15.0 * S),
            activity: ActivityType::Running,
        };

        let uuid = app
            .add_record(RecordType::TimeDistanceRecord(record.clone()))
            .expect("did not create a record");
        let rec = app
            .get_record(&uuid)
            .expect("should be able to retrieve record");
        assert_eq!(rec, Some(RecordType::TimeDistanceRecord(record)));
    }

    #[test]
    fn it_handles_both_record_types() {
        let mut app = standard_app();

        let date = Utc::now();
        let td_record = TimeDistance {
            timestamp: date,
            comments: Some(String::from("just some notes")),
            distance: Some(25.0 * M),
            duration: Some(15.0 * S),
            activity: ActivityType::Running,
        };
        let w_record = WeightRecord {
            date,
            weight: Weight::new(85.0 * KG),
        };

        let td_id = app
            .add_record(RecordType::TimeDistanceRecord(td_record.clone()))
            .expect("add_record should succeed");
        let w_id = app
            .add_record(RecordType::WeightRecord(w_record.clone()))
            .expect("add_record should succeed");

        assert_eq!(
            app.get_record(&w_id).expect("no errors on get"),
            Some(RecordType::WeightRecord(w_record))
        );
        assert_eq!(
            app.get_record(&td_id).expect("no errors on get"),
            Some(RecordType::TimeDistanceRecord(td_record))
        );
    }

    #[test]
    fn it_updates_a_weight() {
        let mut app = standard_app();

        let date = Utc::now();
        let record = WeightRecord {
            date,
            weight: Weight::new(85.0 * KG),
        };
        let record_ = WeightRecord {
            date,
            weight: Weight::new(87.0 * KG),
        };

        let uuid = app
            .add_record(RecordType::WeightRecord(record.clone()))
            .expect("did not create a record");
        app.replace_record(uuid.clone(), RecordType::WeightRecord(record_.clone()))
            .unwrap();

        let rec = app
            .get_record(&uuid)
            .expect("should be able to retrieve record");
        assert_eq!(rec, Some(RecordType::WeightRecord(record_)));
    }

    #[test]
    fn it_updates_a_time_distance() {
        let mut app = standard_app();

        let date = Utc::now();
        let record = TimeDistance {
            timestamp: date,
            comments: Some(String::from("just some notes")),
            distance: Some(25.0 * M),
            duration: Some(15.0 * S),
            activity: ActivityType::Running,
        };
        let record_ = TimeDistance {
            timestamp: date,
            comments: Some(String::from("just some notes")),
            distance: Some(27.0 * M),
            duration: Some(15.0 * S),
            activity: ActivityType::Running,
        };

        let uuid = app
            .add_record(RecordType::TimeDistanceRecord(record.clone()))
            .expect("did not create a record");
        app.replace_record(
            uuid.clone(),
            RecordType::TimeDistanceRecord(record_.clone()),
        )
        .unwrap();

        let rec = app
            .get_record(&uuid)
            .expect("should be able to retrieve record");
        assert_eq!(rec, Some(RecordType::TimeDistanceRecord(record_)));
    }

    /*
    #[test]
    fn it_deletes_a_weight() {
        unimplemented!()
    }

    #[test]
    fn it_deletes_a_time_distance() {
        unimplemented!()
    }
    */
}
