extern crate chrono;
extern crate chrono_tz;
extern crate dimensioned;
extern crate emseries;
#[macro_use]
extern crate serde_derive;
extern crate fitnesstrax;
extern crate serde_json;

use chrono::prelude::*;
use chrono_tz::America::{Chicago, New_York};
use chrono_tz::Etc::UTC;
use dimensioned::si::{KG, M, S};
use std::env;
use std::io;
use std::io::BufRead;

#[derive(Debug, Serialize, Deserialize)]
struct LegacyRecord<T> {
    id: emseries::UniqueId,
    data: T,
}

#[derive(Debug, Serialize, Deserialize)]
struct LegacyWeightRecord {
    weight: f64,
    date: DateTime<Utc>,
}

#[derive(Debug, Serialize, Deserialize)]
struct LegacyTimeDistanceRecord {
    distance: Option<f64>,
    date: DateTime<Utc>,
    activity: fitnesstrax::ActivityType,
    comments: Option<String>,
    duration: Option<f64>,
}

fn usage() {
    println!("usage: load_records <weight|timedistance> < input.series >> output.series");
}

fn main() {
    let args = env::args().collect::<Vec<String>>();
    let move_date = emseries::DateTimeTz(Chicago.ymd(2017, 1, 4).and_hms(0, 0, 0));
    match args.get(1) {
        Some(val) => {
            if val == "weight" {
                let stdin = io::stdin();
                for line in stdin.lock().lines() {
                    let legacy =
                        serde_json::from_str::<LegacyRecord<LegacyWeightRecord>>(&line.unwrap())
                            .unwrap();

                    let date = emseries::DateTimeTz(legacy.data.date.clone().with_timezone(&UTC));
                    let date_ = if date < move_date {
                        date.map(|dt| dt.with_timezone(&Chicago))
                    } else {
                        date.map(|dt| dt.with_timezone(&New_York))
                    };

                    let updated = emseries::Record {
                        id: legacy.id.clone(),
                        data: fitnesstrax::TraxRecord::Weight(fitnesstrax::WeightRecord {
                            date: date_,
                            weight: fitnesstrax::Weight::new(legacy.data.weight * KG),
                        }),
                    };
                    println!("{}", serde_json::to_string(&updated).unwrap());
                }
            } else if val == "timedistance" {
                let stdin = io::stdin();
                for line in stdin.lock().lines() {
                    let l = line.unwrap();
                    let legacy =
                        serde_json::from_str::<LegacyRecord<LegacyTimeDistanceRecord>>(&l).unwrap();

                    let date = emseries::DateTimeTz(legacy.data.date.clone().with_timezone(&UTC));
                    let date_ = if date < move_date {
                        date.map(|dt| dt.with_timezone(&Chicago))
                    } else {
                        date.map(|dt| dt.with_timezone(&New_York))
                    };

                    let updated = emseries::Record {
                        id: legacy.id.clone(),
                        data: fitnesstrax::TraxRecord::TimeDistance(fitnesstrax::TimeDistance {
                            activity: legacy.data.activity.clone(),
                            comments: legacy.data.comments.clone(),
                            distance: legacy.data.distance.map(|d| d * M),
                            duration: legacy.data.duration.map(|d| d * S),
                            timestamp: date_,
                        }),
                    };
                    println!("{}", serde_json::to_string(&updated).unwrap());
                }
            } else {
                usage()
            }
        }
        None => usage(),
    }
}
