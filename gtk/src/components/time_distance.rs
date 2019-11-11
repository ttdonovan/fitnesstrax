use dimensioned;
use emseries::*;
use gtk::prelude::*;

use fitnesstrax;

use super::date_and_time::time_c;

fn activity_c(activity: &fitnesstrax::timedistance::ActivityType) -> gtk::Label {
    gtk::Label::new(match activity {
        fitnesstrax::timedistance::ActivityType::Cycling => Some("Cycling"),
        fitnesstrax::timedistance::ActivityType::Rowing => Some("Rowing"),
        fitnesstrax::timedistance::ActivityType::Running => Some("Running"),
        fitnesstrax::timedistance::ActivityType::Swimming => Some("Swimming"),
        fitnesstrax::timedistance::ActivityType::Walking => Some("Walking"),
    })
}

fn distance_c(distance: &dimensioned::si::Meter<f64>) -> gtk::Label {
    gtk::Label::new(Some(&format!("{} m", distance.value_unsafe)))
}

fn duration_c(duration: &dimensioned::si::Second<f64>) -> gtk::Label {
    gtk::Label::new(Some(&format!("{} s", duration.value_unsafe)))
}

pub fn time_distance_c(record: &fitnesstrax::timedistance::TimeDistanceRecord) -> gtk::Box {
    let container = gtk::Box::new(gtk::Orientation::Horizontal, 5);

    container.add(&time_c(&record.timestamp().0.time()));
    container.add(&activity_c(&record.activity));
    container.add(
        &record
            .distance
            .map(|r| distance_c(&r))
            .unwrap_or(gtk::Label::new(Some("---"))),
    );
    container.add(
        &record
            .duration
            .map(|r| duration_c(&r))
            .unwrap_or(gtk::Label::new(Some("---"))),
    );

    return container;
}
