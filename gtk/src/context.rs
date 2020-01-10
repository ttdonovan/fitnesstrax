use chrono::Utc;
use chrono_tz;
use glib::Sender;
use std::path::PathBuf;

use super::config::Configuration;
use super::errors::Result;
use super::range::Range;
use crate::errors::Error;
use crate::types::DateRange;
use emseries::{DateTimeTz, Record, UniqueId};
use fitnesstrax::{Trax, TraxRecord};

#[derive(Clone, Debug)]
pub enum Message {
    ChangeRange {
        range: DateRange,
        records: Vec<Record<TraxRecord>>,
    },
    ChangeLanguage(String),
    ChangeTimezone(chrono_tz::Tz),
    ChangeUnits(String),
    RecordsUpdated {
        range: DateRange,
        records: Vec<Record<TraxRecord>>,
    },
}

pub struct AppContext {
    config: Configuration,
    trax: Trax,
    range: DateRange,
    channel: Sender<Message>,
}

impl AppContext {
    pub fn new(channel: Sender<Message>) -> Result<AppContext> {
        let config = Configuration::load_from_yaml();

        let trax = fitnesstrax::Trax::new(fitnesstrax::Params {
            series_path: config.series_path.clone(),
        })?;

        let range = Range::new(
            Utc::now().with_timezone(&config.timezone).date() - chrono::Duration::days(7),
            Utc::now().with_timezone(&config.timezone).date(),
        );

        Ok(AppContext {
            config,
            trax,
            range,
            channel,
        })
    }

    pub fn get_series_path(&self) -> &str {
        self.config.series_path.to_str().unwrap()
    }

    pub fn set_series_path(&mut self, path: &str) {
        self.config.series_path = PathBuf::from(path);
    }

    pub fn get_language(&self) -> &str {
        &self.config.language
    }

    pub fn set_language(&mut self, language: &str) {
        {
            self.config.language = String::from(language);
            self.config.save_to_yaml();
        }
        self.send_notifications(Message::ChangeLanguage(self.config.language.clone()));
    }

    pub fn get_timezone(&self) -> chrono_tz::Tz {
        self.config.timezone
    }

    pub fn set_timezone(&mut self, timezone: chrono_tz::Tz) {
        {
            self.config.timezone = timezone;
            self.config.save_to_yaml();
        }
        self.send_notifications(Message::ChangeTimezone(self.config.timezone.clone()));
    }

    pub fn get_units(&self) -> &str {
        &self.config.units
    }

    pub fn set_units(&mut self, units: &str) {
        {
            self.config.units = String::from(units);
            self.config.save_to_yaml();
        }
        self.send_notifications(Message::ChangeUnits(self.config.units.clone()));
    }

    pub fn get_range(&self) -> DateRange {
        self.range.clone()
    }

    pub fn get_history(&self) -> Result<Vec<Record<TraxRecord>>> {
        let start_time = DateTimeTz(
            self.range
                .start
                .and_hms(0, 0, 0)
                .with_timezone(&self.config.timezone),
        );
        let end_time = DateTimeTz(
            (self.range.end + chrono::Duration::days(1))
                .and_hms(0, 0, 0)
                .with_timezone(&self.config.timezone),
        );
        self.trax
            .get_history(start_time, end_time)
            .map_err(|err| Error::TraxError(err))
    }

    pub fn save_records(
        &mut self,
        updated_records: Vec<(UniqueId, TraxRecord)>,
        new_records: Vec<TraxRecord>,
    ) {
        for (id, record) in updated_records {
            let _ = self.trax.replace_record(id, record);
        }
        for record in new_records {
            let _ = self.trax.add_record(record);
        }
        let history = self.get_history().unwrap();
        self.send_notifications(Message::RecordsUpdated {
            range: self.range.clone(),
            records: history,
        });
    }

    pub fn set_range(&mut self, range: DateRange) {
        self.range = range.clone();
        let history = self.get_history().unwrap();
        self.send_notifications(Message::ChangeRange {
            range,
            records: history,
        });
    }

    fn send_notifications(&self, msg: Message) {
        //println!("dispatching message: {:?}", msg);
        self.channel.send(msg).unwrap();
    }
}
