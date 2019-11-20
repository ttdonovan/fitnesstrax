use gtk::prelude::*;
//use gtk::StateFlags;

use super::basics::date_c;
use super::rep_duration::rep_duration_c;
use super::set_rep::set_rep_c;
use super::steps::steps_c;
use super::time_distance::time_distance_c;
use super::weight::weight_record_c;

pub fn day_c(
    date: &chrono::Date<chrono_tz::Tz>,
    data: &Vec<emseries::Record<fitnesstrax::TraxRecord>>,
) -> gtk::Box {
    let container = gtk::Box::new(gtk::Orientation::Vertical, 5);

    /*
    println!("{:?}", container.get_style_context());
    println!(
        "{:?}",
        container
            .get_style_context()
            .get_background_color(StateFlags::NORMAL)
    );
    */

    let header = gtk::Box::new(gtk::Orientation::Horizontal, 5);
    header.pack_start(&date_c(&date), false, false, 5);
    container.pack_start(&header, false, false, 5);

    let first_row = gtk::Box::new(gtk::Orientation::Horizontal, 5);
    container.pack_start(&first_row, false, false, 5);

    let mut weight_component = None;
    let mut step_component = None;
    let mut rep_duration_components: Vec<gtk::Box> = Vec::new();
    let mut set_rep_components: Vec<gtk::Box> = Vec::new();
    let mut time_distance_components: Vec<gtk::Box> = Vec::new();
    for record in data {
        match record.data {
            fitnesstrax::TraxRecord::Comments(ref _rec) => (),
            fitnesstrax::TraxRecord::RepDuration(ref rec) => {
                rep_duration_components.push(rep_duration_c(&rec))
            }
            fitnesstrax::TraxRecord::SetRep(ref rec) => set_rep_components.push(set_rep_c(&rec)),
            fitnesstrax::TraxRecord::Steps(ref rec) => step_component = Some(steps_c(&rec)),
            fitnesstrax::TraxRecord::TimeDistance(ref rec) => {
                time_distance_components.push(time_distance_c(&rec))
            }
            fitnesstrax::TraxRecord::Weight(ref rec) => {
                weight_component = Some(weight_record_c(&rec))
            }
        }
    }

    weight_component.map(|c| first_row.pack_start(&c, false, false, 5));
    step_component.map(|c| first_row.pack_start(&c, false, false, 5));
    for component in time_distance_components {
        container.pack_start(&component, false, false, 5);
    }
    for component in set_rep_components {
        container.pack_start(&component, false, false, 5);
    }
    for component in rep_duration_components {
        container.pack_start(&component, false, false, 5);
    }

    return container;
}
