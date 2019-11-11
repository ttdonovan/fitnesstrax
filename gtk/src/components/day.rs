use gtk::prelude::*;

use super::date_and_time::date_c;
use super::steps::steps_c;
use super::time_distance::time_distance_c;
use super::weight::weight_record_c;

pub fn day_c(
    date: &chrono::Date<chrono_tz::Tz>,
    data: &Vec<emseries::Record<fitnesstrax::TraxRecord>>,
) -> gtk::Box {
    let container = gtk::Box::new(gtk::Orientation::Vertical, 5);
    container.add(&date_c(&date));

    let first_row = gtk::Box::new(gtk::Orientation::Horizontal, 5);
    container.add(&first_row);

    let mut weight_component = None;
    let mut step_component = None;
    let mut time_distance_components: Vec<gtk::Box> = Vec::new();
    for record in data {
        match record.data {
            fitnesstrax::TraxRecord::Weight(ref rec) => {
                weight_component = Some(weight_record_c(&rec))
            }
            fitnesstrax::TraxRecord::Steps(ref rec) => step_component = Some(steps_c(&rec)),
            fitnesstrax::TraxRecord::TimeDistance(ref rec) => {
                time_distance_components.push(time_distance_c(&rec))
            }
            _ => (),
        }
    }

    weight_component.map(|c| first_row.add(&c));
    step_component.map(|c| first_row.add(&c));
    for component in time_distance_components {
        container.add(&component);
    }

    return container;
}
