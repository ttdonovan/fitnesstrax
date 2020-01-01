extern crate dimensioned;
extern crate emseries;
extern crate serde;
#[macro_use]
extern crate serde_derive;
extern crate serde_json;

use dimensioned::si::{Kilogram, Meter, Second};
use emseries::DateTimeTz;
use std::path;

pub mod error;
mod types;
mod utils;
pub use error::{Error, Result};
pub use types::comments;
pub use types::repduration;
pub use types::setrep;
pub use types::steps;
pub use types::timedistance;
pub use types::weight;

#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
pub enum TraxRecord {
    Comments(comments::Comments),
    RepDuration(repduration::RepDurationRecord),
    SetRep(setrep::SetRepRecord),
    Steps(steps::StepRecord),
    TimeDistance(timedistance::TimeDistanceRecord),
    Weight(weight::WeightRecord),
}

impl TraxRecord {
    pub fn steps(timestamp: DateTimeTz, value: u32) -> TraxRecord {
        TraxRecord::Steps(steps::StepRecord::new(timestamp, value))
    }

    pub fn repduration(
        timestamp: DateTimeTz,
        activity: repduration::ActivityType,
        reps: Vec<Second<f64>>,
        comments: Option<String>,
    ) -> TraxRecord {
        TraxRecord::RepDuration(repduration::RepDurationRecord::new(
            timestamp, activity, reps, comments,
        ))
    }

    pub fn setrep(
        timestamp: DateTimeTz,
        activity: setrep::ActivityType,
        sets: Vec<u32>,
        comments: Option<String>,
    ) -> Result<TraxRecord> {
        setrep::SetRepRecord::new(timestamp, activity, sets, comments)
            .map(|r| TraxRecord::SetRep(r))
    }

    pub fn timedistance(
        timestamp: DateTimeTz,
        activity: timedistance::ActivityType,
        distance: Option<Meter<f64>>,
        duration: Option<Second<f64>>,
        comments: Option<String>,
    ) -> TraxRecord {
        TraxRecord::TimeDistance(timedistance::TimeDistanceRecord::new(
            timestamp, activity, distance, duration, comments,
        ))
    }

    pub fn weight(timestamp: DateTimeTz, weight: Kilogram<f64>) -> TraxRecord {
        TraxRecord::Weight(weight::WeightRecord::new(timestamp, weight))
    }
}

impl From<steps::StepRecord> for TraxRecord {
    fn from(r: steps::StepRecord) -> TraxRecord {
        TraxRecord::Steps(r)
    }
}

impl From<timedistance::TimeDistanceRecord> for TraxRecord {
    fn from(r: timedistance::TimeDistanceRecord) -> TraxRecord {
        TraxRecord::TimeDistance(r)
    }
}

impl From<weight::WeightRecord> for TraxRecord {
    fn from(r: weight::WeightRecord) -> TraxRecord {
        TraxRecord::Weight(r)
    }
}

impl emseries::Recordable for TraxRecord {
    fn timestamp(&self) -> DateTimeTz {
        match self {
            TraxRecord::Comments(rec) => rec.timestamp(),
            TraxRecord::RepDuration(rec) => rec.timestamp(),
            TraxRecord::SetRep(rec) => rec.timestamp(),
            TraxRecord::Steps(rec) => rec.timestamp(),
            TraxRecord::TimeDistance(rec) => rec.timestamp(),
            TraxRecord::Weight(rec) => rec.timestamp(),
        }
    }

    fn tags(&self) -> Vec<String> {
        match self {
            TraxRecord::Comments(rec) => rec.tags(),
            TraxRecord::RepDuration(rec) => rec.tags(),
            TraxRecord::SetRep(rec) => rec.tags(),
            TraxRecord::Steps(rec) => rec.tags(),
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
        start: DateTimeTz,
        end: DateTimeTz,
    ) -> Result<Vec<emseries::Record<TraxRecord>>> {
        self.series
            .search(emseries::And {
                lside: emseries::StartTime {
                    time: start,
                    incl: true,
                },
                rside: emseries::EndTime {
                    time: end,
                    incl: false,
                },
            })
            .map_err(Error::from)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use chrono::TimeZone;
    use chrono_tz::Etc::UTC;
    use dimensioned::si::{KG, M, S};
    use utils::CleanupFile;

    use types::timedistance;
    use types::weight;

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

        let date = DateTimeTz(UTC.ymd(2019, 5, 15).and_hms(12, 0, 0).with_timezone(&UTC));
        let record = weight::WeightRecord::new(date, 85.0 * KG);

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

        let date = DateTimeTz(UTC.ymd(2019, 5, 15).and_hms(12, 0, 0).with_timezone(&UTC));
        let record = timedistance::TimeDistanceRecord::new(
            date,
            timedistance::ActivityType::Running,
            Some(25.0 * M),
            Some(15.0 * S),
            Some(String::from("just some notes")),
        );

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

        let date = DateTimeTz(UTC.ymd(2019, 5, 15).and_hms(12, 0, 0).with_timezone(&UTC));
        let td_record = timedistance::TimeDistanceRecord::new(
            date.clone(),
            timedistance::ActivityType::Running,
            Some(25.0 * M),
            Some(15.0 * S),
            Some(String::from("just some notes")),
        );
        let w_record = weight::WeightRecord::new(date, 85.0 * KG);

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
        let date = DateTimeTz(UTC.ymd(2019, 5, 15).and_hms(12, 0, 0).with_timezone(&UTC));
        let series_path = path::PathBuf::from("var/it_saves_both_record_types_to_file.series");
        let _cleanup = CleanupFile(series_path.clone());

        let (td_id, w_id) = {
            let mut trax = Trax::new(Params {
                series_path: series_path.clone(),
            })
            .expect("the app to be created");

            let td_record = timedistance::TimeDistanceRecord::new(
                date.clone(),
                timedistance::ActivityType::Running,
                Some(25.0 * M),
                Some(15.0 * S),
                Some(String::from("just some notes")),
            );
            let w_record = weight::WeightRecord::new(date.clone(), 85.0 * KG);

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
        assert_eq!(w_record, Some(TraxRecord::weight(date.clone(), 85.0 * KG)));

        let td_record = trax.get_record(&td_id).unwrap();
        assert_eq!(
            td_record,
            Some(TraxRecord::timedistance(
                date,
                timedistance::ActivityType::Running,
                Some(25.0 * M),
                Some(15.0 * S),
                Some(String::from("just some notes")),
            ))
        );
    }

    #[test]
    fn it_updates_a_weight() {
        let (mut app, _cleanup) = standard_app("it_updates_a_weight.series");

        let date = DateTimeTz(UTC.ymd(2019, 5, 15).and_hms(12, 0, 0).with_timezone(&UTC));
        let record = weight::WeightRecord::new(date.clone(), 85.0 * KG);
        let record_ = weight::WeightRecord::new(date, 87.0 * KG);

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

        let date = DateTimeTz(UTC.ymd(2019, 5, 15).and_hms(12, 0, 0).with_timezone(&UTC));
        let record = timedistance::TimeDistanceRecord::new(
            date.clone(),
            timedistance::ActivityType::Running,
            Some(25.0 * M),
            Some(15.0 * S),
            Some(String::from("just some notes")),
        );
        let record_ = timedistance::TimeDistanceRecord::new(
            date,
            timedistance::ActivityType::Running,
            Some(27.0 * M),
            Some(15.0 * S),
            Some(String::from("just some notes")),
        );

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
