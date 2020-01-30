use chrono_tz::Tz;
use std::convert::TryFrom;

use crate::config::Configuration;
use crate::i18n::{Text, UnitSystem};

#[derive(Clone, Debug)]
pub struct Settings {
    pub timezone: Tz,
    pub units: UnitSystem,
    pub text: Text,
}

impl Settings {
    pub fn new(lang_str: &str, units_str: &str, timezone: chrono_tz::Tz) -> Settings {
        let units = UnitSystem::try_from(units_str).expect("invalid unit system identifier");

        let langid = lang_str.parse().expect("Language parsing failed");
        let text = Text::new(langid, units.clone());

        Settings {
            timezone,
            units,
            text,
        }
    }

    pub fn from_config(config: &Configuration) -> Settings {
        Settings::new(&config.language, &config.units, config.timezone)
    }

    pub fn set_language(&mut self, lang_str: &str) {
        let langid = lang_str.parse().expect("Language parsing failed");
        self.text = Text::new(langid, self.units.clone());
    }

    pub fn set_units(&mut self, units_str: &str) {
        self.units = UnitSystem::try_from(units_str).expect("invalid unit system identifier");
    }

    pub fn set_timezone(&mut self, timezone: chrono_tz::Tz) {
        self.timezone = timezone;
    }
}
