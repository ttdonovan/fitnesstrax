use dimensioned::si::{Kilogram, KG};
use regex::Regex;

use crate::errors::Error;

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
