use chrono::NaiveTime;
use dimensioned::si;

use crate::errors::Error;
use crate::i18n::UnitSystem;

pub fn render_mass(inp: &si::Kilogram<f64>, units: &UnitSystem, display_units: bool) -> String {
    let value_str = match units {
        UnitSystem::SI => inp.value_unsafe,
        UnitSystem::USA => (*inp / si::LB).value_unsafe,
    };
    let unit_str = match (display_units, units) {
        (false, _) => "",
        (true, UnitSystem::SI) => " kg",
        (true, UnitSystem::USA) => " lbs",
    };
    format!("{:.2}{}", value_str, unit_str)
}

pub fn parse_mass(inp: &str, units: &UnitSystem) -> Result<Option<si::Kilogram<f64>>, Error> {
    inp.parse::<f64>()
        .map(|v| match units {
            UnitSystem::SI => Some(v * si::KG),
            UnitSystem::USA => Some(v * si::LB),
        })
        .map_err(|_| Error::ParseMassError)
}

pub fn render_hours_minutes(inp: &NaiveTime) -> String {
    format!("{}", inp.format("%H:%M"))
}

pub fn parse_hours_minutes(inp: &str) -> Result<NaiveTime, Error> {
    NaiveTime::parse_from_str(inp, "%H:%M").map_err(|_| Error::ParseTimeError)
}

pub fn render_duration(inp: &si::Second<f64>) -> String {
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

pub fn parse_duration(inp: &str) -> Result<Option<si::Second<f64>>, Error> {
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
            Ok(Some((seconds + minutes * 60.0 + hours * 3600.0) * si::S))
        }
        2 => {
            let seconds = parts[1]
                .parse::<f64>()
                .map_err(|_| Error::ParseDurationError)?;
            let minutes = parts[0]
                .parse::<f64>()
                .map_err(|_| Error::ParseDurationError)?;
            Ok(Some((seconds + minutes * 60.0) * si::S))
        }
        1 => parts[0]
            .parse::<f64>()
            .map(|f| Some(f * si::S))
            .map_err(|_| Error::ParseDurationError),
        0 => Ok(None),
        _ => Err(Error::ParseDurationError),
    }
}

pub fn render_distance(inp: &si::Meter<f64>, units: &UnitSystem, display_units: bool) -> String {
    let value_str = match units {
        UnitSystem::SI => inp.value_unsafe / 1000.0,
        UnitSystem::USA => (*inp / si::FT).value_unsafe / 5280.0,
    };
    let unit_str = match (display_units, units) {
        (false, _) => "",
        (true, UnitSystem::SI) => " km",
        (true, UnitSystem::USA) => " mi",
    };
    format!("{:.2}{}", value_str, unit_str)
}

pub fn parse_distance(inp: &str, units: &UnitSystem) -> Result<Option<si::Meter<f64>>, Error> {
    if inp.len() == 0 {
        return Ok(None);
    }

    inp.parse::<f64>()
        .map(|v| match units {
            UnitSystem::SI => Some(v * 1000.0 * si::M),
            UnitSystem::USA => Some(v * si::MI),
        })
        .map_err(|_| Error::ParseDistanceError)
}
