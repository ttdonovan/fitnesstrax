use chrono::TimeZone;
use chrono_tz;
use serde::{Deserialize, Serialize};
use std::env;
use std::error;
use std::fs::File;
use std::path;

use super::config::Configuration;
use super::errors::Result;
use super::range::Range;
use emseries::Record;
use fitnesstrax::{Trax, TraxRecord};

type DateRange = Range<chrono::Date<chrono_tz::Tz>>;

#[derive(Clone, Debug)]
pub enum Message {
    ChangeRange {
        range: DateRange,
        records: Vec<Record<TraxRecord>>,
    },
    ChangeLanguage,
    ChangeTimezone(chrono_tz::Tz),
}

pub struct AppContext {
    config: Configuration,
    trax: Trax,
    range: DateRange,

    listeners: Vec<Box<dyn Fn(Message)>>,
}

impl AppContext {
    pub fn new() -> Result<AppContext> {
        let config = Configuration::load_from_yaml();

        let trax = fitnesstrax::Trax::new(fitnesstrax::Params {
            series_path: config.series_path.clone(),
        })?;

        let range = Range::new(
            /*
            Utc::today().with_timezone(&config_.timezone) - chrono::Duration::days(7),
            Utc::today().with_timezone(&config_.timezone),
            */
            chrono::Utc.ymd(2019, 9, 1).with_timezone(&config.timezone),
            chrono::Utc.ymd(2019, 9, 30).with_timezone(&config.timezone),
        );

        Ok(AppContext {
            config,
            trax,
            range,
            listeners: Vec::new(),
        })
    }

    fn send_notifications(&self, msg: Message) {
        self.listeners.iter().for_each(|f| f(msg.clone()))
    }

    pub fn register_listener(&mut self, listener: Box<dyn Fn(Message)>) {
        self.listeners.push(listener);
    }
}
