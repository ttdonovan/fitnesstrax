extern crate chrono;
extern crate dimensioned;
extern crate emseries;
extern crate serde;
#[macro_use] extern crate structopt;

extern crate fitnesstrax;

use chrono::{ Local, DateTime, TimeZone, Utc };
use dimensioned::si::{ M, Meter, S, Second };
use emseries::{ Record, Series, Tags };
use fitnesstrax::{ ActivityType, TimeDistance };
use std::env;
use std::num::ParseFloatError;
use structopt::StructOpt;

#[derive(Debug, StructOpt)]
struct Options {
    #[structopt(long = "cycling")]
    cycling: bool,
    #[structopt(long = "running")]
    running: bool,
    #[structopt(long = "comments")]
    comments: Option<String>,
    #[structopt(long = "datetime")]
    datetime: String,
    #[structopt(long = "distance")]
    distance: Option<f64>,
    #[structopt(long  = "duration")]
    duration: Option<String>,
}

fn parse_duration(inp: &str) -> Result<Second<f64>, ParseFloatError> {
    let values = inp.split(":").map(|v| v.parse::<f64>()).collect::<Result<Vec<f64>, ParseFloatError>>()?;
    println!("[parse_duration] {:?}", values);
    if values.len() == 2 {
        return Ok((values[0] * 60. + values[1]) * S);
    } else if values.len() == 1 {
        return Ok(values[0] * S);
    } else {
        panic!("invalid duration provided");
    }
}

fn main() {
    let dbpath = env::var("DB_PATH").expect("set DB_PATH");
    let options = Options::from_args();

    println!("[Options] {:?}", options);
    
    let activity = match (options.cycling, options.running) {
        (true, false) => ActivityType::Cycling,
        (false, true) => ActivityType::Running,
        (_, _) => panic!("one of --cycling or --running must be specified")
    };

    let datetime = Local.datetime_from_str(&options.datetime, "%Y-%m-%d %H:%M:%S")
                    .or(Local.datetime_from_str(&options.datetime, "%Y-%m-%dT%H:%M:%S"))
                    .unwrap_or(Local::now());
    let distance = options.distance.map(|v| (v * 1000.).round() * M);
    let duration = options.duration.map(|v| parse_duration(&v).expect("need a valid MM:SS value"));

    let td = TimeDistance::new(activity, options.comments, datetime.with_timezone(&Utc), distance, duration);
    println!("[TimeDistance] {:?}", td);

    let mut series: Series<TimeDistance> =
        Series::open(&dbpath).expect("series should open correctly");

    let rec_id = series.put(td).unwrap();

    let rec = series.get(&rec_id);
    println!("[New Record] {:?}", rec);

    /*
    let mut series: Series<TimeDistance> =
        Series::open(&dbpath).expect("series should open correctly");
    let records = series.all_records().unwrap();
    println!("Discovered {} records", records.len());

    let running_records: Vec<Record<TimeDistance>> = records.iter().filter(|r| r.data.activity == ActivityType::Running).cloned().collect();
    let running_records = series.search(Tags{ tags: vec![String::from("Running")] }).unwrap();
    println!("Discovered {} running records", running_records.len());
    */
}

