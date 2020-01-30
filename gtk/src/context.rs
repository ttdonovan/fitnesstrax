use chrono::Utc;
use glib::Sender;
use std::path::PathBuf;

use crate::config::Configuration;
use crate::errors::{Error, Result};
use crate::range::Range;
use crate::settings::Settings;
use crate::types::DateRange;
use emseries::{DateTimeTz, Record, UniqueId};
use fitnesstrax::{Trax, TraxRecord};

#[derive(Clone, Debug)]
pub enum Message {
    ChangeRange {
        settings: Settings,
        range: DateRange,
        records: Vec<Record<TraxRecord>>,
    },
    ChangeSettings {
        settings: Settings,
        range: DateRange,
        records: Vec<Record<TraxRecord>>,
    },
    RecordsUpdated {
        settings: Settings,
        range: DateRange,
        records: Vec<Record<TraxRecord>>,
    },
}

pub struct AppContext {
    series_path: PathBuf,
    settings: Settings,
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

        let settings = Settings::from_config(&config);

        Ok(AppContext {
            series_path: config.series_path,
            settings,
            trax,
            range,
            channel,
        })
    }

    pub fn get_series_path(&self) -> &str {
        self.series_path.to_str().unwrap()
    }

    pub fn set_series_path(&mut self, path: &str) {
        self.series_path = PathBuf::from(path);
    }

    pub fn get_settings(&self) -> Settings {
        self.settings.clone()
    }

    pub fn set_language(&mut self, language_str: &str) {
        self.settings.set_language(language_str);
        self.send_notifications(Message::ChangeSettings {
            settings: self.settings.clone(),
            range: self.range.clone(),
            records: self.get_history().unwrap(),
        });
    }

    pub fn set_timezone(&mut self, timezone: chrono_tz::Tz) {
        self.settings.set_timezone(timezone);
        self.send_notifications(Message::ChangeSettings {
            settings: self.settings.clone(),
            range: self.range.clone(),
            records: self.get_history().unwrap(),
        });
    }

    pub fn set_units(&mut self, units_str: &str) {
        self.settings.set_units(units_str);
        self.send_notifications(Message::ChangeSettings {
            settings: self.settings.clone(),
            range: self.range.clone(),
            records: self.get_history().unwrap(),
        });
    }

    /*
    pub fn set_settings(&mut self, settings: Settings) {
        {
            if settings.text != self.settings.language {
                self.translations = Translations::new(&settings.language);
            }
            self.settings = settings;

            let config = Configuration {
                series_path: self.series_path.clone(),
                language: self.settings.language.clone(),
                timezone: self.settings.timezone,
                units: String::from(self.settings.units.clone()),
            };
            config.save_to_yaml();
        }
        self.send_notifications(Message::ChangePreferences {
            settings: self.settings.clone(),
            range: self.range.clone(),
            records: self.get_history().unwrap(),
        });
    }
    */

    pub fn get_range(&self) -> DateRange {
        self.range.clone()
    }

    pub fn get_history(&self) -> Result<Vec<Record<TraxRecord>>> {
        let start_time = DateTimeTz(
            self.range
                .start
                .and_hms(0, 0, 0)
                .with_timezone(&self.settings.timezone),
        );
        let end_time = DateTimeTz(
            (self.range.end + chrono::Duration::days(1))
                .and_hms(0, 0, 0)
                .with_timezone(&self.settings.timezone),
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
            settings: self.settings.clone(),
            range: self.range.clone(),
            records: history,
        });
    }

    pub fn set_range(&mut self, range: DateRange) {
        self.range = range.clone();
        let history = self.get_history().unwrap();
        self.send_notifications(Message::ChangeRange {
            settings: self.settings.clone(),
            range,
            records: history,
        });
    }

    fn send_notifications(&self, msg: Message) {
        //println!("dispatching message: {:?}", msg);
        self.channel.send(msg).unwrap();
    }
}
