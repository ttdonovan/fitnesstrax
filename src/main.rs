extern crate chrono;
extern crate dimensioned;
extern crate emseries;
extern crate serde;

extern crate fitnesstrax;

use chrono::{ Local, Utc };
use dimensioned::si::KG;
use emseries::{ Series };
use fitnesstrax::{ Weight, WeightRecord };
use std::env;


fn main() {
    let dbpath = env::var("DB_PATH").expect("set DB_PATH");
    let args: Vec<String> = env::args().collect();

    if args.len() <= 1 {
        println!("Include a weight in the parameter list");
    }

    let timestamp = Local::today().and_hms(0, 0, 0);
    let weight = args[1].parse::<f64>().expect("enter a valid floating point number");

    let mut series: Series<WeightRecord> =
        Series::open(&dbpath)
               .expect("series should open correctly");

    let rec_id = series.put(
        WeightRecord{
            date: timestamp.with_timezone(&Utc),
            weight: Weight::new(weight * KG) })
        .expect("failed to record entry");

    let rec = series.get(&rec_id);
    println!("[New Record] {:?}", rec);
}

