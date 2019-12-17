use chrono::{DateTime, TimeZone};
use chrono_tz;
use glib::Sender;
use serde::{Deserialize, Serialize};

use super::config::Configuration;
use super::errors::Result;
use super::range::Range;
use crate::errors::Error;
use crate::types::DateRange;
use emseries::{DateTimeTz, Record};
use fitnesstrax::{Trax, TraxRecord};

#[derive(Clone, Debug)]
pub enum Message {
    ChangeRange {
        range: DateRange,
        //records: Vec<Record<TraxRecord>>,
    },
    ChangeLanguage,
    ChangeTimezone(chrono_tz::Tz),
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
            channel,
        })
    }

    pub fn get_timezone(&self) -> chrono_tz::Tz {
        self.config.timezone
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
            self.range
                .end
                .and_hms(0, 0, 0)
                .with_timezone(&self.config.timezone),
        );
        self.trax
            .get_history(start_time, end_time)
            .map_err(|err| Error::TraxError(err))
    }

    pub fn set_range(&mut self, range: DateRange) {
        self.range = range.clone();
        self.send_notifications(Message::ChangeRange { range });
    }

    fn send_notifications(&self, msg: Message) {
        println!("dispatching message: {:?}", msg);
        self.channel.send(msg).unwrap();
    }

    /*
    pub fn register_listener(&mut self) -> Receiver<Message> {
        let (tx, rx) = channel();
        self.listeners.push(tx);
        rx
    }
    */
}
