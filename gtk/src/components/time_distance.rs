use gtk::prelude::*;

use emseries::*;
use fitnesstrax;

#[allow(non_snake_case)]
pub fn time_distance_c(record: &fitnesstrax::timedistance::TimeDistanceRecord) -> gtk::Box {
    let container = gtk::Box::new(gtk::Orientation::Horizontal, 5);

    let time_label = gtk::Label::new(Some(
        &(format!("{}", record.timestamp().0.time().format("%H:%M:%S"))),
    ));
    container.add(&time_label);

    return container;
}
