use dimensioned::si::Second;
use gtk::prelude::*;

use crate::settings::Settings;
use fitnesstrax;

fn activity_c(activity: &fitnesstrax::repduration::ActivityType) -> gtk::Label {
    gtk::Label::new(match activity {
        fitnesstrax::repduration::ActivityType::MartialArts => Some("MartialArts"),
        fitnesstrax::repduration::ActivityType::Planks => Some("Planks"),
        fitnesstrax::repduration::ActivityType::Yoga => Some("Yoga"),
    })
}

fn sets_c(sets: &Vec<Second<f64>>) -> gtk::Label {
    let set_strs: Vec<String> = sets.iter().map(|r| format!("{}", r)).collect();
    gtk::Label::new(Some(&set_strs.join(" ")))
}

pub fn rep_duration_c(
    record: &fitnesstrax::repduration::RepDurationRecord,
    _settings: &Settings,
) -> gtk::Box {
    let container = gtk::Box::new(gtk::Orientation::Horizontal, 5);

    container.add(&activity_c(&record.activity));
    container.add(&sets_c(&record.sets));

    container
}
