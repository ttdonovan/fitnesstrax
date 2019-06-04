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

pub mod types;
pub use self::types::{ActivityType, TimeDistanceRecord, WeightRecord};

#[derive(Debug)]
pub enum Error {
    NoSeries,
    SeriesError(emseries::Error),
}

impl From<emseries::Error> for Error {
    fn from(error: emseries::Error) -> Self {
        Error::SeriesError(error)
    }
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
pub enum TraxRecord {
    TimeDistance(TimeDistanceRecord),
    Weight(WeightRecord),
}

impl emseries::Recordable for TraxRecord {
    fn timestamp(&self) -> DateTime<Utc> {
        match self {
            TraxRecord::TimeDistance(rec) => rec.timestamp(),
            TraxRecord::Weight(rec) => rec.timestamp(),
        }
    }

    fn tags(&self) -> Vec<String> {
        match self {
            TraxRecord::TimeDistance(rec) => rec.tags(),
            TraxRecord::Weight(rec) => rec.tags(),
        }
    }
}

#[derive(Clone, Debug)]
pub struct Params {
    pub series_path: path::PathBuf,
}

pub struct Trax {
    series: emseries::Series<TraxRecord>,
}

impl Trax {
    pub fn new(params: Params) -> Result<Trax> {
        let series = emseries::Series::open(params.series_path.to_str().unwrap())
            .map_err(|err| Error::SeriesError(err))?;

        Ok(Trax { series })
    }

    pub fn add_record(&mut self, record: TraxRecord) -> Result<emseries::UniqueId> {
        self.series
            .put(record)
            .map_err(|err| Error::SeriesError(err))
    }

    pub fn replace_record(
        &mut self,
        uid: emseries::UniqueId,
        record: TraxRecord,
    ) -> Result<emseries::UniqueId> {
        self.series
            .update(emseries::Record {
                id: uid.clone(),
                data: record,
            })
            .map_err(|err| Error::SeriesError(err))?;
        Ok(uid)
    }

    pub fn get_record(&self, uid: &emseries::UniqueId) -> Result<Option<TraxRecord>> {
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

    pub fn get_history(
        &self,
        start: DateTime<Utc>,
        end: DateTime<Utc>,
    ) -> Result<Vec<emseries::Record<TraxRecord>>> {
        self.series
            .search(emseries::And {
                lside: emseries::StartTime {
                    time: start,
                    incl: true,
                },
                rside: emseries::EndTime {
                    time: end,
                    incl: true,
                },
            })
            .map_err(Error::from)
    }
}

#[cfg(test)]
mod tests {
    use super::super::utils::CleanupFile;
    use super::*;
    use dimensioned::si::{KG, M, S};

    use trax::types::{ActivityType, TimeDistance, Weight, WeightRecord};

    fn standard_app(filename: &str) -> (Trax, CleanupFile) {
        let series_path = path::PathBuf::from(format!("var/{}", filename));
        let trax = Trax::new(Params {
            series_path: series_path.clone(),
        })
        .expect("the app to be created");
        let cleanup = CleanupFile(series_path);
        (trax, cleanup)
    }

    #[test]
    fn it_records_and_retrieves_a_new_weight() {
        let (mut app, _cleanup) = standard_app("it_records_and_retrieves_a_new_weight.series");

        let date = Utc::now();
        let record = WeightRecord {
            date,
            weight: Weight::new(85.0 * KG),
        };

        let uuid = app
            .add_record(TraxRecord::Weight(record.clone()))
            .expect("did not create a record");
        let rec = app
            .get_record(&uuid)
            .expect("should be able to retrieve record");
        assert_eq!(rec, Some(TraxRecord::Weight(record)));
    }

    #[test]
    fn it_records_and_retrieves_new_time_distance() {
        let (mut app, _cleanup) = standard_app("it_records_and_retrieves_new_time_distance.series");

        let date = Utc::now();
        let record = TimeDistance {
            timestamp: date,
            comments: Some(String::from("just some notes")),
            distance: Some(25.0 * M),
            duration: Some(15.0 * S),
            activity: ActivityType::Running,
        };

        let uuid = app
            .add_record(TraxRecord::TimeDistance(record.clone()))
            .expect("did not create a record");
        let rec = app
            .get_record(&uuid)
            .expect("should be able to retrieve record");
        assert_eq!(rec, Some(TraxRecord::TimeDistance(record)));
    }

    #[test]
    fn it_handles_both_record_types() {
        let (mut app, _cleanup) = standard_app("it_handles_both_record_types.series");

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
            .add_record(TraxRecord::TimeDistance(td_record.clone()))
            .expect("add_record should succeed");
        let w_id = app
            .add_record(TraxRecord::Weight(w_record.clone()))
            .expect("add_record should succeed");

        assert_eq!(
            app.get_record(&w_id).expect("no errors on get"),
            Some(TraxRecord::Weight(w_record))
        );
        assert_eq!(
            app.get_record(&td_id).expect("no errors on get"),
            Some(TraxRecord::TimeDistance(td_record))
        );
    }

    #[test]
    fn it_saves_both_record_types_to_file() {
        let date = Utc::now();
        let series_path = path::PathBuf::from("var/it_saves_both_record_types_to_file.series");
        let _cleanup = CleanupFile(series_path.clone());

        let (td_id, w_id) = {
            let mut trax = Trax::new(Params {
                series_path: series_path.clone(),
            })
            .expect("the app to be created");

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

            let td_id = trax
                .add_record(TraxRecord::TimeDistance(td_record))
                .expect("add_record should succeed");
            let w_id = trax
                .add_record(TraxRecord::Weight(w_record))
                .expect("add_record should succeed");

            (td_id, w_id)
        };

        let trax = Trax::new(Params {
            series_path: series_path.clone(),
        })
        .expect("the app to load again");

        let w_record = trax.get_record(&w_id).unwrap();
        assert_eq!(
            w_record,
            Some(TraxRecord::Weight(WeightRecord {
                date,
                weight: Weight::new(85.0 * KG)
            }))
        );

        let td_record = trax.get_record(&td_id).unwrap();
        assert_eq!(
            td_record,
            Some(TraxRecord::TimeDistance(TimeDistance {
                timestamp: date,
                comments: Some(String::from("just some notes")),
                distance: Some(25.0 * M),
                duration: Some(15.0 * S),
                activity: ActivityType::Running
            }))
        );
    }

    #[test]
    fn it_updates_a_weight() {
        let (mut app, _cleanup) = standard_app("it_updates_a_weight.series");

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
            .add_record(TraxRecord::Weight(record.clone()))
            .expect("did not create a record");
        app.replace_record(uuid.clone(), TraxRecord::Weight(record_.clone()))
            .unwrap();

        let rec = app
            .get_record(&uuid)
            .expect("should be able to retrieve record");
        assert_eq!(rec, Some(TraxRecord::Weight(record_)));
    }

    #[test]
    fn it_updates_a_time_distance() {
        let (mut app, _cleanup) = standard_app("it_updates_a_time_distance.series");

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
            .add_record(TraxRecord::TimeDistance(record.clone()))
            .expect("did not create a record");
        app.replace_record(uuid.clone(), TraxRecord::TimeDistance(record_.clone()))
            .unwrap();

        let rec = app
            .get_record(&uuid)
            .expect("should be able to retrieve record");
        assert_eq!(rec, Some(TraxRecord::TimeDistance(record_)));
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
