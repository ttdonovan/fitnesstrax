extern crate chrono;
extern crate dimensioned;
extern crate emseries;
extern crate serde;
extern crate serde_json;
#[macro_use] extern crate structopt;

extern crate fitnesstrax;

use chrono::{ TimeZone, Local, Utc };
use dimensioned::si::KG;
use emseries::{ Series, UniqueId, time_range };
use fitnesstrax::{ Weight, WeightRecord };
use structopt::StructOpt;
use std::env;


fn main() {
    let dbpath = env::var("DB_PATH").expect("set DB_PATH");
    let args: Vec<String> = env::args().collect();

    if args.len() <= 1 {
        println!("Include a weight in the parameter list");
    }

    let timestamp = Local::today().and_hms(0, 0, 0);
    let weight = args[1].parse::<f64>().expect("enter a valid floating point number");

    /*
    println!("{}", timestamp);
    println!("{}", timestamp.with_timezone(&Utc));
    println!("{:?}", weight);
    */

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

    /*
    let recs = series.all_records().expect("record retrieval failed");
    for rec in recs {
        println!("[Record] {:?}", rec);
    }

    let id = UniqueId::from_str("3330c5b0-783f-4919-b2c4-8169c38f65ff").expect("oops, there's something wrong with this uuid");
    let r = series.get(&id);
    println!("[Record retrieved by UUID] {:?}", r);

    series.put(WeightRecord{ date: Utc::now(), weight: Weight::new(81.0 * KG) });
    */
}

