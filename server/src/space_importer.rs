extern crate chrono;
extern crate chrono_tz;
extern crate dimensioned;
extern crate emseries;
extern crate fitnesstrax;

use chrono::prelude::*;
use chrono_tz::America::{Chicago, New_York};
use dimensioned::si::{Second, S};
//use chrono_tz::Etc::UTC;
use std::env;
use std::io;
use std::io::BufRead;

fn usage() {
    println!("A utility for loading a space-separated file into the series");
    println!("usage: space_importer health.series < space_separated.txt >> output.series");
}

fn parse_date(s: &str) -> Result<NaiveDate, std::num::ParseIntError> {
    let date_parts: Vec<&str> = s.split("-").collect();
    let year: i32 = str::parse::<i32>(date_parts[0])?;
    let month: u32 = str::parse::<u32>(date_parts[1])?;
    let day: u32 = str::parse::<u32>(date_parts[2])?;

    Ok(NaiveDate::from_ymd(year, month, day))
}

fn parse_duration(s: &str) -> Result<Second<f64>, std::num::ParseFloatError> {
    let time_parts: Vec<&str> = s.split(":").collect();
    if time_parts.len() == 1 {
        let seconds = str::parse::<f64>(time_parts[0])?;
        Ok(seconds * S)
    } else if time_parts.len() == 2 {
        let minutes = str::parse::<f64>(time_parts[0])?;
        let seconds = str::parse::<f64>(time_parts[1])?;
        Ok(minutes * 60. * S + seconds * S)
    } else if time_parts.len() == 3 {
        let hours = str::parse::<f64>(time_parts[0])?;
        let minutes = str::parse::<f64>(time_parts[1])?;
        let seconds = str::parse::<f64>(time_parts[2])?;
        Ok(hours * 3600. * S + minutes * 60. * S + seconds * S)
    } else {
        panic!("invalid time specified");
    }
}

#[derive(Debug)]
enum RecordType {
    Kayaking,
    Lunges,
    Plank,
    Pushups,
    Situps,
    Squats,
    Steps,
    TaiChi,
}

impl From<&str> for RecordType {
    fn from(s: &str) -> Self {
        match s {
            "Kayaking" => RecordType::Kayaking,
            "Lunges" => RecordType::Lunges,
            "Plank" => RecordType::Plank,
            "Pushups" => RecordType::Pushups,
            "Situps" => RecordType::Situps,
            "Squats" => RecordType::Squats,
            "Steps" => RecordType::Steps,
            "TaiChi" => RecordType::TaiChi,
            &_ => panic!("unrecognized record type string: {}", s),
        }
    }
}

impl From<&String> for RecordType {
    fn from(s: &String) -> Self {
        RecordType::from(s as &str)
    }
}

impl From<String> for RecordType {
    fn from(s: String) -> Self {
        RecordType::from(&s as &str)
    }
}

fn main() {
    let args = env::args().collect::<Vec<String>>();
    let move_date = NaiveDate::from_ymd(2017, 1, 4);

    match args.get(1) {
        Some(val) => {
            let mut series: emseries::Series<fitnesstrax::trax::TraxRecord> =
                emseries::Series::open(val).unwrap();

            let stdin = io::stdin();
            for line in stdin.lock().lines() {
                let parts: Vec<String> = line
                    .unwrap()
                    .split(" ")
                    .filter(|s| s != &"")
                    .map(|s| String::from(s))
                    .collect();
                let date = parse_date(&parts[0]).unwrap();
                let date_ = if date < move_date {
                    emseries::DateTimeTz(
                        Chicago.from_local_datetime(&date.and_hms(0, 0, 0)).unwrap(),
                    )
                } else {
                    emseries::DateTimeTz(
                        New_York
                            .from_local_datetime(&date.and_hms(0, 0, 0))
                            .unwrap(),
                    )
                };
                let activity = RecordType::from(&parts[1]);
                let params = &parts[2..];

                let record = match activity {
                    RecordType::Lunges => None,
                    RecordType::Kayaking => {
                        let duration = parse_duration(&params[0]).unwrap();
                        Some(fitnesstrax::TraxRecord::timedistance(
                            date_,
                            fitnesstrax::trax::timedistance::ActivityType::Rowing,
                            None,
                            Some(duration),
                            None,
                        ))
                    }
                    RecordType::Plank => {
                        let durations: Vec<Second<f64>> = params
                            .iter()
                            .map(|v| parse_duration(&v))
                            .collect::<Result<Vec<Second<f64>>, std::num::ParseFloatError>>()
                            .unwrap();
                        Some(fitnesstrax::TraxRecord::repduration(
                            date_,
                            fitnesstrax::trax::repduration::ActivityType::Planks,
                            durations,
                            None,
                        ))
                    }
                    RecordType::Pushups => {
                        let sets: Vec<u32> = params
                            .iter()
                            .map(|v| str::parse::<u32>(v))
                            .collect::<Result<Vec<u32>, std::num::ParseIntError>>()
                            .unwrap();
                        Some(
                            fitnesstrax::TraxRecord::setrep(
                                date_,
                                fitnesstrax::trax::setrep::ActivityType::Pushups,
                                sets,
                                None,
                            )
                            .unwrap(),
                        )
                    }
                    RecordType::Situps => {
                        let sets: Vec<u32> = params
                            .iter()
                            .map(|v| str::parse::<u32>(v))
                            .collect::<Result<Vec<u32>, std::num::ParseIntError>>()
                            .unwrap();
                        Some(
                            fitnesstrax::TraxRecord::setrep(
                                date_,
                                fitnesstrax::trax::setrep::ActivityType::Situps,
                                sets,
                                None,
                            )
                            .unwrap(),
                        )
                    }
                    RecordType::Squats => {
                        let sets: Vec<u32> = params
                            .iter()
                            .map(|v| str::parse::<u32>(v))
                            .collect::<Result<Vec<u32>, std::num::ParseIntError>>()
                            .unwrap();
                        Some(
                            fitnesstrax::TraxRecord::setrep(
                                date_,
                                fitnesstrax::trax::setrep::ActivityType::Squats,
                                sets,
                                None,
                            )
                            .unwrap(),
                        )
                    }
                    RecordType::Steps => {
                        let count = str::parse::<u32>(&params[0]).unwrap();
                        Some(fitnesstrax::TraxRecord::steps(date_, count))
                    }
                    RecordType::TaiChi => {
                        let duration = parse_duration(&params[0]).unwrap();
                        Some(fitnesstrax::TraxRecord::repduration(
                            date_,
                            fitnesstrax::trax::repduration::ActivityType::MartialArts,
                            vec![duration],
                            None,
                        ))
                    }
                };
                match record {
                    Some(r) => {
                        series.put(r).unwrap();
                        ()
                    }
                    None => (),
                }
            }
        }
        None => usage(),
    }
}
