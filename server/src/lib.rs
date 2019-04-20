extern crate chrono;
extern crate dimensioned;
extern crate emseries;
extern crate serde;
#[macro_use]
extern crate serde_derive;
#[macro_use] extern crate serde_json;

mod logging;
mod staticfile;
mod types;

use std::error;
use std::fmt;
use std::path;
use std::result;

pub use logging::LoggingMiddleware;
pub use staticfile::StaticHandler;
pub use types::{ActivityType, TimeDistance, TimeDistanceRecord, Weight, WeightRecord};

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

type Result<A> = result::Result<A, Error>;

#[derive(Clone, Debug, PartialEq, Serialize)]
#[serde(untagged)]
pub enum RecordType {
    TimeDistanceRecord(TimeDistanceRecord),
    WeightRecord(WeightRecord),
}

#[derive(Clone, Debug, Serialize)]
#[serde(untagged)]
pub enum RecordId {
    TimeDistanceRecordId(emseries::UniqueId),
    WeightRecordId(emseries::UniqueId),
}

impl RecordId {
    pub fn unwrap(&self) -> emseries::UniqueId {
        match self {
            RecordId::TimeDistanceRecordId(uid) => uid.clone(),
            RecordId::WeightRecordId(uid) => uid.clone(),
        }
    }
}

#[derive(Clone, Debug)]
pub struct Params {
    pub time_distance_path: Option<path::PathBuf>,
    pub weight_path: Option<path::PathBuf>,
}

pub struct App {
    time_distance_series: Option<emseries::Series<TimeDistanceRecord>>,
    weight_series: Option<emseries::Series<WeightRecord>>,
}

impl App {
    pub fn new(params: Params) -> Result<App> {
        fn open_series<A>(path: Option<path::PathBuf>) -> Result<Option<emseries::Series<A>>>
        where
            A: Clone + emseries::Recordable + serde::de::DeserializeOwned + serde::ser::Serialize,
        {
            match path {
                None => Ok(None),
                Some(p) => {
                    emseries::Series::open(p.to_str().unwrap())
                        .map(|s| Some(s))
                        .map_err(|err| Error::SeriesError(err))
                }
            }
        }

        let time_distance_series = open_series::<TimeDistanceRecord>(params.time_distance_path)?;
        let weight_series = open_series::<WeightRecord>(params.weight_path)?;

        Ok(App {
            time_distance_series,
            weight_series,
        })
    }

    pub fn add_record(&mut self, record: RecordType) -> Result<RecordId> {
        fn add_record_<A>(
            series: &mut Option<emseries::Series<A>>,
            r: A,
        ) -> Result<emseries::UniqueId>
        where
            A: Clone + emseries::Recordable + serde::de::DeserializeOwned + serde::ser::Serialize,
        {
            match series {
                None => Err(Error::NoSeries),
                Some(series) => series.put(r).map_err(|err| Error::SeriesError(err)),
            }
        }

        match record {
            RecordType::TimeDistanceRecord(r) => {
                add_record_(&mut self.time_distance_series, r).map(|uid| {
                    RecordId::TimeDistanceRecordId(uid)
                })
            }
            RecordType::WeightRecord(r) => {
                add_record_(&mut self.weight_series, r).map(|uid| RecordId::WeightRecordId(uid))
            }
        }
    }

    pub fn replace_record(&mut self, rid: RecordId, record: RecordType) -> Result<RecordId> {
        fn replace_record_<A>(
            series: &mut Option<emseries::Series<A>>,
            uid: &emseries::UniqueId,
            r: A,
        ) -> Result<()>
        where
            A: Clone + emseries::Recordable + serde::de::DeserializeOwned + serde::ser::Serialize,
        {
            match series {
                None => Err(Error::NoSeries),
                Some(series) => {
                    series
                        .update(emseries::Record {
                            id: uid.clone(),
                            data: r,
                        })
                        .map_err(|err| Error::SeriesError(err))
                }
            }
        }

        match (rid, record) {
            (RecordId::TimeDistanceRecordId(uid), RecordType::TimeDistanceRecord(r)) => {
                replace_record_(&mut self.time_distance_series, &uid, r)?;
                Ok(RecordId::TimeDistanceRecordId(uid))
            }
            (RecordId::WeightRecordId(uid), RecordType::WeightRecord(r)) => {
                replace_record_(&mut self.weight_series, &uid, r)?;
                Ok(RecordId::WeightRecordId(uid))
            }
            _ => panic!("type mismatch between record id type and record type"),
        }
    }

    pub fn get_record(&self, rid: &RecordId) -> Result<Option<RecordType>> {
        fn get_record_<A>(
            series: &Option<emseries::Series<A>>,
            uid: &emseries::UniqueId,
        ) -> Result<Option<A>>
        where
            A: Clone + emseries::Recordable + serde::de::DeserializeOwned + serde::ser::Serialize,
        {
            match series {
                None => Err(Error::NoSeries),
                Some(series) => {
                    series.get(uid).map(|mr| mr.map(|r| r.data)).map_err(
                        |err| {
                            Error::SeriesError(err)
                        },
                    )
                }
            }
        }

        match rid {
            RecordId::TimeDistanceRecordId(td_uid) => {
                get_record_(&self.time_distance_series, td_uid).map(|mr| {
                    mr.map(|r| RecordType::TimeDistanceRecord(r))
                })
            }
            RecordId::WeightRecordId(w_uid) => {
                get_record_(&self.weight_series, w_uid).map(|mr| {
                    mr.map(|r| RecordType::WeightRecord(r))
                })
            }
        }
    }

    pub fn remove_record(&mut self, rid: &RecordId) -> Result<()> {
        fn remove_record_<A>(
            series: &mut Option<emseries::Series<A>>,
            uid: &emseries::UniqueId,
        ) -> Result<()>
        where
            A: Clone + emseries::Recordable + serde::de::DeserializeOwned + serde::ser::Serialize,
        {
            match series {
                None => Err(Error::NoSeries),
                Some(series) => series.delete(uid).map_err(|err| Error::SeriesError(err)),
            }
        }

        match rid {
            RecordId::TimeDistanceRecordId(td_uid) => {
                remove_record_(&mut self.time_distance_series, td_uid)
            }
            RecordId::WeightRecordId(w_uid) => remove_record_(&mut self.weight_series, w_uid),
        }
    }
}


#[cfg(test)]
mod tests {
    use super::*;
    use chrono::prelude::*;
    use dimensioned::si::{KG, M, S};

    fn standard_app() -> App {
        App::new(Params {
            weight_path: Some(path::PathBuf::from("var/weight_test.series")),
            time_distance_path: Some(path::PathBuf::from("var/time_distance_test.series")),
        }).expect("the app to be created")
    }

    fn app_without_weight() -> App {
        App::new(Params {
            weight_path: None,
            time_distance_path: Some(path::PathBuf::from("var/time_distance_test.series")),
        }).expect("the app to be created")
    }

    #[test]
    fn it_records_and_retrieves_a_new_weight() {
        let mut app = standard_app();

        let date = Utc::now();
        let record = WeightRecord {
            date,
            weight: Weight::new(85.0 * KG),
        };

        let uuid = app.add_record(RecordType::WeightRecord(record.clone()))
            .expect("did not create a record");
        let rec = app.get_record(&uuid).expect(
            "should be able to retrieve record",
        );
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

        let uuid = app.add_record(RecordType::TimeDistanceRecord(record.clone()))
            .expect("did not create a record");
        let rec = app.get_record(&uuid).expect(
            "should be able to retrieve record",
        );
        assert_eq!(rec, Some(RecordType::TimeDistanceRecord(record)));
    }

    #[test]
    fn it_keeps_record_types_separate() {
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

        let td_id = app.add_record(RecordType::TimeDistanceRecord(td_record.clone()))
            .expect("add_record should succeed");
        let w_id = app.add_record(RecordType::WeightRecord(w_record.clone()))
            .expect("add_record should succeed");

        let weight_wrap_td_id = RecordId::WeightRecordId(td_id.unwrap());
        let time_distance_wrap_w_id = RecordId::TimeDistanceRecordId(w_id.unwrap());

        assert_eq!(
            app.get_record(&w_id).expect("no errors on get"),
            Some(RecordType::WeightRecord(w_record))
        );
        assert_eq!(
            app.get_record(&weight_wrap_td_id).expect(
                "no errors on get",
            ),
            None
        );
        assert_eq!(
            app.get_record(&td_id).expect("no errors on get"),
            Some(RecordType::TimeDistanceRecord(td_record))
        );
        assert_eq!(
            app.get_record(&time_distance_wrap_w_id).expect(
                "no errors on get",
            ),
            None
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

        let uuid = app.add_record(RecordType::WeightRecord(record.clone()))
            .expect("did not create a record");
        app.replace_record(uuid.clone(), RecordType::WeightRecord(record_.clone()))
            .unwrap();

        let rec = app.get_record(&uuid).expect(
            "should be able to retrieve record",
        );
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

        let uuid = app.add_record(RecordType::TimeDistanceRecord(record.clone()))
            .expect("did not create a record");
        app.replace_record(
            uuid.clone(),
            RecordType::TimeDistanceRecord(record_.clone()),
        ).unwrap();

        let rec = app.get_record(&uuid).expect(
            "should be able to retrieve record",
        );
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

    #[test]
    fn it_rejects_weights_when_series_is_not_open() {
        let mut app = app_without_weight();
        let date = Utc::now();
        let record = WeightRecord {
            date,
            weight: Weight::new(85.0 * KG),
        };

        let res = app.add_record(RecordType::WeightRecord(record.clone()));
        match res {
            Err(Error::NoSeries) => (),
            Err(_) => panic!("unexpected error"),
            Ok(_) => panic!("adding a record should have failed"),
        }
    }
}
