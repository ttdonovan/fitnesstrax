use chrono::NaiveTime;
use dimensioned::si::{Kilogram, Meter, Second, KG, M, S};
use regex::Regex;

use crate::errors::Error;

/*
// Needing this conversion around because apparently Dimensioned doesn't include conversions
// between FPS and SI. That seems silly, but I don't want to figure out how to retrofit it.
const KG_PER_POUND: f64 = 0.4535924;

pub fn parse_mass(inp: &str) -> Result<Kilogram<f64>, Error> {
    let re = Regex::new(r"(\d+\.?\d+)\s?(\w+)").unwrap();
    let captures = re.captures(inp);
    match captures {
        Some(caps) => match caps.len() {
            0 => Err(Error::ParseMassError),
            1 => Err(Error::ParseMassError),
            2 => Err(Error::ParseMassError),
            _ => {
                let val = caps[1].parse::<f64>().map_err(|_| Error::ParseMassError)?;
                match caps[2].to_lowercase().as_str() {
                    "kg" => Ok(val * KG),
                    "lb" => Ok(val * KG_PER_POUND * KG),
                    _ => Err(Error::ParseMassError),
                }
            }
        },
        None => Err(Error::ParseMassError),
    }
}
*/

pub fn render_hours_minutes(inp: &NaiveTime) -> String {
    format!("{}", inp.format("%H:%M"))
}

pub fn parse_hours_minutes(inp: &str) -> Result<NaiveTime, Error> {
    NaiveTime::parse_from_str(inp, "%H:%M").map_err(|_| Error::ParseTimeError)
}

pub fn render_duration(inp: &Second<f64>) -> String {
    let seconds = inp.value_unsafe.rem_euclid(60.0) as i8;
    let minutes = (inp.value_unsafe / 60.0).rem_euclid(60.0) as i8;
    let hours = (inp.value_unsafe / 3600.0) as i32;

    if hours == 0 {
        if minutes == 0 {
            format!("{:02}", seconds)
        } else {
            format!("{:02}:{:02}", minutes, seconds)
        }
    } else {
        format!("{:02}:{:02}:{:02}", hours, minutes, seconds)
    }
}

pub fn parse_duration(inp: &str) -> Result<Option<Second<f64>>, Error> {
    let parts: Vec<&str> = inp.split(":").collect();
    match parts.len() {
        3 => {
            let seconds = parts[2]
                .parse::<f64>()
                .map_err(|_| Error::ParseDurationError)?;
            let minutes = parts[1]
                .parse::<f64>()
                .map_err(|_| Error::ParseDurationError)?;
            let hours = parts[0]
                .parse::<f64>()
                .map_err(|_| Error::ParseDurationError)?;
            Ok(Some((seconds + minutes * 60.0 + hours * 3600.0) * S))
        }
        2 => {
            let seconds = parts[1]
                .parse::<f64>()
                .map_err(|_| Error::ParseDurationError)?;
            let minutes = parts[0]
                .parse::<f64>()
                .map_err(|_| Error::ParseDurationError)?;
            Ok(Some((seconds + minutes * 60.0) * S))
        }
        1 => parts[0]
            .parse::<f64>()
            .map(|f| Some(f * S))
            .map_err(|_| Error::ParseDurationError),
        0 => Ok(None),
        _ => Err(Error::ParseDurationError),
    }
}

pub fn render_distance(inp: &Meter<f64>) -> String {
    format!("{}", inp.value_unsafe / 1000.0)
}

pub fn parse_distance(inp: &str) -> Result<Option<Meter<f64>>, Error> {
    if inp.len() == 0 {
        return Ok(None);
    }

    inp.parse::<f64>()
        .map(|f| Some(f * 1000.0 * M))
        .map_err(|_| Error::ParseDistanceError)
}
