use gtk::prelude::*;

use crate::settings::Settings;
use fitnesstrax;

fn activity_c(activity: &fitnesstrax::setrep::ActivityType) -> gtk::Label {
    gtk::Label::new(match activity {
        fitnesstrax::setrep::ActivityType::Pushups => Some("Pushups"),
        fitnesstrax::setrep::ActivityType::Situps => Some("Situps"),
        fitnesstrax::setrep::ActivityType::Squats => Some("Squats"),
    })
}

fn sets_c(sets: &Vec<u32>) -> gtk::Label {
    let set_strs: Vec<String> = sets.iter().map(|r| format!("{}", r)).collect();
    gtk::Label::new(Some(&set_strs.join(" ")))
}

pub fn set_rep_c(record: &fitnesstrax::setrep::SetRepRecord, _settings: &Settings) -> gtk::Box {
    let container = gtk::Box::new(gtk::Orientation::Horizontal, 5);

    container.add(&activity_c(&record.activity));
    container.add(&sets_c(&record.sets));

    container
}
