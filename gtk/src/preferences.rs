use chrono_tz::Tz;
use std::convert::TryFrom;

use crate::errors::Error;

#[derive(Clone, Debug)]
pub enum UnitSystem {
    SI,
    USA,
}

impl From<UnitSystem> for String {
    fn from(units: UnitSystem) -> String {
        match units {
            UnitSystem::SI => String::from("SI"),
            UnitSystem::USA => String::from("USA"),
        }
    }
}

impl TryFrom<&str> for UnitSystem {
    type Error = Error;

    fn try_from(s: &str) -> Result<UnitSystem, Error> {
        match s {
            "SI" => Ok(UnitSystem::SI),
            "USA" => Ok(UnitSystem::USA),
            _ => Err(Error::ParseUnitsError),
        }
    }
}

#[derive(Clone, Debug)]
pub struct Preferences {
    pub language: String,
    pub timezone: Tz,
    pub units: UnitSystem,
}
