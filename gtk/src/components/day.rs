use gtk::prelude::*;
use std::sync::{Arc, RwLock};

use crate::components::basics::date_c;
use crate::components::rep_duration::rep_duration_c;
use crate::components::set_rep::set_rep_c;
use crate::components::steps::steps_c;
use crate::components::time_distance::time_distance_c;
use crate::components::weight::{weight_record_c, weight_record_edit_c};

pub struct Day {
    pub widget: gtk::Box,
    visible_component: Arc<RwLock<gtk::Box>>,
    edit: Arc<RwLock<bool>>,
    date: chrono::Date<chrono_tz::Tz>,
    records: Arc<RwLock<Vec<emseries::Record<fitnesstrax::TraxRecord>>>>,
}

impl Day {
    pub fn new(
        date: chrono::Date<chrono_tz::Tz>,
        records: Vec<emseries::Record<fitnesstrax::TraxRecord>>,
    ) -> Day {
        let widget = gtk::Box::new(gtk::Orientation::Vertical, 5);

        let header = gtk::Box::new(gtk::Orientation::Horizontal, 5);
        header.pack_start(&date_c(&date), false, false, 5);

        widget.pack_start(&header, false, false, 5);

        let visible = day_c(&date, &records);
        widget.pack_start(&visible, true, true, 5);

        let w = Day {
            widget,
            visible_component: Arc::new(RwLock::new(visible)),
            edit: Arc::new(RwLock::new(false)),
            date,
            records: Arc::new(RwLock::new(records)),
        };

        {
            let widget_ = w.widget.clone();
            let visible_ = w.visible_component.clone();
            let edit_button = gtk::Button::new_with_label("Edit");
            let records_ = w.records.clone();
            header.pack_start(&edit_button, false, false, 5);
            edit_button.connect_clicked(move |_| {
                let mut v = visible_.write().unwrap();
                widget_.remove(&*v);
                *v = day_edit_c(&date, &records_.read().unwrap());
                widget_.pack_start(&*v, true, true, 5);
            });
        }

        w
    }

    pub fn update_from(
        &self,
        date: chrono::Date<chrono_tz::Tz>,
        records: Vec<emseries::Record<fitnesstrax::TraxRecord>>,
    ) {
    }

    pub fn show(&self) {
        self.widget.show_all();
    }
}

fn day_c(
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

    container.show_all();
    return container;
}

fn day_edit_c(
    date: &chrono::Date<chrono_tz::Tz>,
    data: &Vec<emseries::Record<fitnesstrax::TraxRecord>>,
) -> gtk::Box {
    let container = gtk::Box::new(gtk::Orientation::Vertical, 5);

    container.pack_start(&gtk::Label::new(Some("edit mode")), false, false, 5);
    let first_row = gtk::Box::new(gtk::Orientation::Horizontal, 5);
    container.pack_start(&first_row, false, false, 5);

    let mut weight_component = None;
    for record in data {
        match record.data {
            fitnesstrax::TraxRecord::Weight(ref rec) => {
                weight_component = Some(weight_record_edit_c(&rec))
            }
            _ => (),
        }
    }
    weight_component.map(|c| first_row.pack_start(&c, false, false, 5));

    container.show_all();
    container
}
