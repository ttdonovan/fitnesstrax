use gtk::prelude::*;

use super::time_distance::time_distance_c;

pub fn day_c(
    date: &chrono::Date<chrono_tz::Tz>,
    data: &Vec<emseries::Record<fitnesstrax::TraxRecord>>,
) -> gtk::Box {
    let container = gtk::Box::new(gtk::Orientation::Vertical, 5);
    let date_label = gtk::Label::new(Some(&(format!("{}", date.format("%B %e, %Y")))));
    container.add(&date_label);

    let mut time_distance_components: Vec<gtk::Box> = Vec::new();
    for record in data {
        match record.data {
            fitnesstrax::TraxRecord::TimeDistance(ref rec) => {
                time_distance_components.push(time_distance_c(&rec))
            }
            _ => (),
        }
    }

    for component in time_distance_components {
        container.add(&component);
    }

    return container;
}
