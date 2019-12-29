use chrono::Timelike;
use emseries::*;
use gtk::prelude::*;
use std::sync::{Arc, RwLock};

use crate::components::basics::{
    distance_c, distance_edit_c, duration_c, duration_edit_c, time_c, time_edit_c,
};
use crate::components::validated_text_entry::ValidatedTextEntry;
use crate::conversions::parse_duration;
use fitnesstrax::timedistance::TimeDistanceRecord;

fn activity_c(activity: &fitnesstrax::timedistance::ActivityType) -> gtk::Label {
    gtk::Label::new(match activity {
        fitnesstrax::timedistance::ActivityType::Cycling => Some("Cycling"),
        fitnesstrax::timedistance::ActivityType::Rowing => Some("Rowing"),
        fitnesstrax::timedistance::ActivityType::Running => Some("Running"),
        fitnesstrax::timedistance::ActivityType::Swimming => Some("Swimming"),
        fitnesstrax::timedistance::ActivityType::Walking => Some("Walking"),
    })
}

pub fn time_distance_c(record: &fitnesstrax::timedistance::TimeDistanceRecord) -> gtk::Box {
    let container = gtk::Box::new(gtk::Orientation::Horizontal, 5);

    container.pack_start(&time_c(&record.timestamp().0.time()), false, false, 5);
    container.pack_start(&activity_c(&record.activity), false, false, 5);
    container.pack_start(
        &record
            .distance
            .map(|r| distance_c(&r))
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
    on_update: Box<dyn Fn(UniqueId, TimeDistanceRecord)>,
) -> gtk::Box {
    let container = gtk::Box::new(gtk::Orientation::Horizontal, 5);
    let record = Arc::new(RwLock::new(record));
    let on_update = Arc::new(RwLock::new(on_update));

    let time_entry = {
        let id = id.clone();
        let record = record.clone();
        let on_update = on_update.clone();
        let time = record.read().unwrap().timestamp().0.time();
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
                });
                (on_update.read().unwrap())(id.clone(), r.clone())
            }),
        )
    };

    let distance_entry = {
        let id = id.clone();
        let record = record.clone();
        let on_update = on_update.clone();
        let distance = record.read().unwrap().distance.clone();
        distance_edit_c(
            &distance,
            Box::new(move |res| match res {
                Some(val) => {
                    let mut r = record.write().unwrap();
                    r.distance = Some(val);
                    (on_update.read().unwrap())(id.clone(), r.clone())
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
                    (on_update.read().unwrap())(id.clone(), r.clone())
                }
                None => (),
            }),
        )

        /*
        ValidatedTextEntry::new(
            duration,
            Box::new(|s| format!("{}", s)),
            Box::new(|s| parse_duration(s)),
            Box::new(move |res| match res {
                Some(val) => {
                    let mut r = record.write().unwrap();
                    r.duration = Some(val);
                    (on_update.read().unwrap())(id.clone(), r.clone())
                }
                None => (),
            }),
        )
        */
    };

    container.pack_start(&time_entry.widget, false, false, 5);
    container.pack_start(&distance_entry.widget, false, false, 5);
    container.pack_start(&gtk::Label::new(Some("km")), false, false, 5);
    container.pack_start(&duration_entry.widget, false, false, 5);

    container
}
