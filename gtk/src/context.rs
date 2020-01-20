use chrono::Utc;
use glib::Sender;
use std::convert::TryFrom;
use std::path::PathBuf;

use crate::config::Configuration;
use crate::errors::{Error, Result};
use crate::i18n::Messages;
use crate::preferences::{Preferences, UnitSystem};
use crate::range::Range;
use crate::types::DateRange;
use emseries::{DateTimeTz, Record, UniqueId};
use fitnesstrax::{Trax, TraxRecord};

#[derive(Clone, Debug)]
pub enum Message {
    ChangeRange {
        prefs: Preferences,
        messages: Messages,
        range: DateRange,
        records: Vec<Record<TraxRecord>>,
    },
    ChangePreferences {
        prefs: Preferences,
        messages: Messages,
        range: DateRange,
        records: Vec<Record<TraxRecord>>,
    },
    RecordsUpdated {
        prefs: Preferences,
        messages: Messages,
        range: DateRange,
        records: Vec<Record<TraxRecord>>,
    },
}

pub struct AppContext {
    series_path: PathBuf,
    prefs: Preferences,
    trax: Trax,
    range: DateRange,
    messages: Messages,
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

        let messages = Messages::new(&config.language);

        Ok(AppContext {
            series_path: config.series_path,
            prefs: Preferences {
                language: config.language,
                timezone: config.timezone,
                units: UnitSystem::try_from(config.units.as_str()).unwrap(),
            },
            trax,
            range,
            channel,
            messages,
        })
    }

    pub fn get_series_path(&self) -> &str {
        self.series_path.to_str().unwrap()
    }

    pub fn set_series_path(&mut self, path: &str) {
        self.series_path = PathBuf::from(path);
    }

    pub fn get_preferences(&self) -> Preferences {
        self.prefs.clone()
    }

    pub fn set_preferences(&mut self, prefs: Preferences) {
        {
            if prefs.language != self.prefs.language {
                self.messages = Messages::new(&prefs.language);
            }
            self.prefs = prefs;

            let config = Configuration {
                series_path: self.series_path.clone(),
                language: self.prefs.language.clone(),
                timezone: self.prefs.timezone,
                units: String::from(self.prefs.units.clone()),
            };
            config.save_to_yaml();
        }
        self.send_notifications(Message::ChangePreferences {
            prefs: self.prefs.clone(),
            messages: self.messages.clone(),
            range: self.range.clone(),
            records: self.get_history().unwrap(),
        });
    }

    pub fn get_range(&self) -> DateRange {
        self.range.clone()
    }

    pub fn get_messages(&self) -> Messages {
        self.messages.clone()
    }

    pub fn get_history(&self) -> Result<Vec<Record<TraxRecord>>> {
        let start_time = DateTimeTz(
            self.range
                .start
                .and_hms(0, 0, 0)
                .with_timezone(&self.prefs.timezone),
        );
        let end_time = DateTimeTz(
            (self.range.end + chrono::Duration::days(1))
                .and_hms(0, 0, 0)
                .with_timezone(&self.prefs.timezone),
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
            prefs: self.prefs.clone(),
            messages: self.messages.clone(),
            range: self.range.clone(),
            records: history,
        });
    }

    pub fn set_range(&mut self, range: DateRange) {
        self.range = range.clone();
        let history = self.get_history().unwrap();
        self.send_notifications(Message::ChangeRange {
            prefs: self.prefs.clone(),
            messages: self.messages.clone(),
            range,
            records: history,
        });
    }

    fn send_notifications(&self, msg: Message) {
        //println!("dispatching message: {:?}", msg);
        self.channel.send(msg).unwrap();
    }
}
