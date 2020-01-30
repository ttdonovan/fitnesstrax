use dimensioned::si;
use std::convert::TryFrom;

use crate::errors::Error;

#[derive(Clone, Debug)]
pub enum UnitSystem {
    SI,
    USA,
}

impl From<&UnitSystem> for String {
    fn from(units: &UnitSystem) -> String {
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

impl UnitSystem {
    pub fn mass(&self, inp: &si::Kilogram<f64>) -> f64 {
        match self {
            UnitSystem::SI => inp.value_unsafe,
            UnitSystem::USA => (*inp / si::LB).value_unsafe,
        }
    }

    pub fn parse_mass(&self, inp: &str) -> Result<Option<si::Kilogram<f64>>, Error> {
        inp.parse::<f64>()
            .map(|v| match self {
                UnitSystem::SI => Some(v * si::KG),
                UnitSystem::USA => Some(v * si::LB),
            })
            .map_err(|_| Error::ParseMassError)
    }
}
