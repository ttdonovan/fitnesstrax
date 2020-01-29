use chrono::Timelike;
use emseries::*;
use gtk::prelude::*;
use std::convert::TryFrom;
use std::sync::{Arc, RwLock};

use crate::components::basics::{
    distance_c, distance_edit_c, duration_c, duration_edit_c, time_c, time_edit_c,
};
use crate::preferences::{Preferences, UnitSystem};
use fitnesstrax::timedistance::{activity_types, ActivityType, TimeDistanceRecord};

fn activity_c(activity: &ActivityType) -> gtk::Label {
    gtk::Label::new(match activity {
        ActivityType::Cycling => Some("Cycling"),
        ActivityType::Rowing => Some("Rowing"),
        ActivityType::Running => Some("Running"),
        ActivityType::Swimming => Some("Swimming"),
        ActivityType::Walking => Some("Walking"),
    })
}

pub fn time_distance_c(
    record: &fitnesstrax::timedistance::TimeDistanceRecord,
    prefs: &Preferences,
) -> gtk::Box {
    let container = gtk::Box::new(gtk::Orientation::Horizontal, 5);

    container.pack_start(
        &time_c(&record.timestamp().0.with_timezone(&prefs.timezone).time()),
        false,
        false,
        5,
    );
    container.pack_start(&activity_c(&record.activity), false, false, 5);
    container.pack_start(
        &record
            .distance
            .map(|r| distance_c(&r, &prefs.units))
            .unwrap_or(gtk::Label::new(Some("---"))),
        false,
        false,
        5,
    );
    container.pack_start(
        &record
            .duration
            .map(|r| duration_c(&r))
            .unwrap_or(gtk::Label::new(Some("---"))),
        false,
        false,
        5,
    );

    return container;
}

pub fn time_distance_record_edit_c(
    id: UniqueId,
    record: TimeDistanceRecord,
    prefs: Preferences,
    on_update: Box<dyn Fn(UniqueId, TimeDistanceRecord)>,
) -> gtk::Box {
    let on_update = Arc::new(on_update);
    let container = gtk::Box::new(gtk::Orientation::Horizontal, 5);
    let record = Arc::new(RwLock::new(record));

    let time_entry = {
        let id = id.clone();
        let record = record.clone();
        let on_update = on_update.clone();
        let time = record
            .read()
            .unwrap()
            .timestamp()
            .0
            .with_timezone(&prefs.timezone)
            .time();
        let prefs = prefs.clone();
        time_edit_c(
            &time,
            Box::new(move |val| {
                let mut r = record.write().unwrap();
                r.timestamp = r.timestamp.map(|ts| {
                    ts.clone()
                        .with_hour(val.hour())
                        .unwrap()
                        .with_minute(val.minute())
                        .unwrap()
                        .with_second(val.second())
                        .unwrap()
                        .with_timezone(&prefs.timezone)
                });
                on_update(id.clone(), r.clone());
            }),
        )
    };

    let activity_selection = {
        let id = id.clone();
        let record = record.clone();
        let on_update = on_update.clone();
        let menu = gtk::ComboBoxText::new();
        for activity in activity_types().iter() {
            let activity_str = format!("{:?}", activity);
            menu.append(Some(&activity_str), &activity_str);
        }
        menu.set_active_id(Some(&format!("{:?}", record.read().unwrap().activity)));
        menu.connect_changed(move |s| match s.get_active_id() {
            Some(val) => {
                let mut r = record.write().unwrap();
                r.activity = ActivityType::try_from(val.as_str()).unwrap();
                on_update(id.clone(), r.clone());
            }
            None => (),
        });
        menu
    };

    let distance_entry = {
        let id = id.clone();
        let record = record.clone();
        let on_update = on_update.clone();
        let distance = record.read().unwrap().distance.clone();
        distance_edit_c(
            &distance,
            &prefs.units,
            Box::new(move |res| match res {
                Some(val) => {
                    let mut r = record.write().unwrap();
                    r.distance = Some(val);
                    on_update(id.clone(), r.clone());
                }
                None => (),
            }),
        )
    };

    let duration_entry = {
        let id = id.clone();
        let record = record.clone();
        let on_update = on_update.clone();
        let duration = record.read().unwrap().duration.clone();
        duration_edit_c(
            &duration,
            Box::new(move |res| match res {
                Some(val) => {
                    let mut r = record.write().unwrap();
                    r.duration = Some(val);
                    on_update(id.clone(), r.clone());
                }
                None => (),
            }),
        )
    };

    let distance_label = match prefs.units {
        UnitSystem::SI => "km",
        UnitSystem::USA => "mi",
    };

    container.pack_start(&time_entry, false, false, 5);
    container.pack_start(&activity_selection, false, false, 5);
    container.pack_start(&distance_entry, false, false, 5);
    container.pack_start(&gtk::Label::new(Some(distance_label)), false, false, 5);
    container.pack_start(&duration_entry, false, false, 5);

    container
}
