use emseries::{Record, UniqueId};
use fitnesstrax::TraxRecord;
use gtk::prelude::*;
use std::collections::HashMap;
use std::sync::{Arc, RwLock};

use crate::components::basics::date_c;
use crate::components::rep_duration::rep_duration_c;
use crate::components::set_rep::set_rep_c;
use crate::components::steps::steps_c;
use crate::components::time_distance::time_distance_c;
use crate::components::weight::{weight_record_c, weight_record_edit_c};

enum DayState {
    View(gtk::Box),
    Edit(DayEdit),
}

#[derive(Clone)]
pub struct Day {
    pub widget: gtk::Box,
    visible_component: Arc<RwLock<DayState>>,
    date: chrono::Date<chrono_tz::Tz>,
    records: HashMap<UniqueId, TraxRecord>,
    updates: Arc<RwLock<HashMap<UniqueId, TraxRecord>>>,
    new_records: Arc<RwLock<HashMap<UniqueId, TraxRecord>>>,
}

impl Day {
    pub fn new(date: chrono::Date<chrono_tz::Tz>, records: Vec<Record<TraxRecord>>) -> Day {
        let widget = gtk::Box::new(gtk::Orientation::Vertical, 5);

        let header = gtk::Box::new(gtk::Orientation::Horizontal, 5);
        header.pack_start(&date_c(&date), false, false, 5);

        widget.pack_start(&header, false, false, 5);

        let visible = day_c(&date, records.iter().map(|rec| &rec.data).collect());
        widget.pack_start(&visible, true, true, 5);

        let record_map = records.iter().fold(HashMap::new(), |mut acc, rec| {
            acc.insert(rec.id.clone(), rec.data.clone());
            acc
        });

        let w = Day {
            widget,
            visible_component: Arc::new(RwLock::new(DayState::View(visible))),
            date,
            records: record_map,
            updates: Arc::new(RwLock::new(HashMap::new())),
            new_records: Arc::new(RwLock::new(HashMap::new())),
        };

        {
            let w_ = w.clone();
            let edit_button = gtk::Button::new_with_label("Edit");
            header.pack_start(&edit_button, false, false, 5);
            edit_button.connect_clicked(move |_| w_.edit());
        }

        w
    }

    fn edit(&self) {
        let mut v = self.visible_component.write().unwrap();
        match *v {
            DayState::View(ref w) => self.widget.remove(w),
            DayState::Edit(_) => return,
        };
        let self_save = self.clone();
        let self_cancel = self.clone();
        let component = DayEdit::new(
            &self.date,
            &self.records,
            Box::new(move |records| self_save.save_edit(records)),
            Box::new(move || self_cancel.cancel_edit()),
        );
        self.widget.pack_start(&component.widget, true, true, 5);
        *v = DayState::Edit(component);
    }

    fn cancel_edit(&self) {
        let mut v = self.visible_component.write().unwrap();
        match *v {
            DayState::View(_) => return,
            DayState::Edit(ref w) => self.widget.remove(&w.widget),
        };
        let component = day_c(&self.date, self.records.values().collect());
        self.widget.pack_start(&component, true, true, 5);
        *v = DayState::View(component);
    }

    fn save_edit(&self, records: Vec<Record<TraxRecord>>) {
        records
            .iter()
            .for_each(|record| println!("record: {:?}", record));
        /* Now, figure out what records are updated or new and pass them to the on_save handler */
    }

    pub fn show(&self) {
        self.widget.show_all();
    }
}

fn day_c(_date: &chrono::Date<chrono_tz::Tz>, data: Vec<&TraxRecord>) -> gtk::Box {
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
        match record {
            TraxRecord::Comments(ref _rec) => (),
            TraxRecord::RepDuration(ref rec) => rep_duration_components.push(rep_duration_c(&rec)),
            TraxRecord::SetRep(ref rec) => set_rep_components.push(set_rep_c(&rec)),
            TraxRecord::Steps(ref rec) => step_component = Some(steps_c(&rec)),
            TraxRecord::TimeDistance(ref rec) => {
                time_distance_components.push(time_distance_c(&rec))
            }
            TraxRecord::Weight(ref rec) => weight_component = Some(weight_record_c(&rec)),
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

struct DayEdit {
    widget: gtk::Box,
    //components: Vec<WeightRecordEditField>,
    //on_save: Box<dyn Fn(Vec<Record<TraxRecord>>)>,
    //on_cancel: Box<dyn Fn()>,
}

impl DayEdit {
    fn new(
        _date: &chrono::Date<chrono_tz::Tz>,
        data: &HashMap<UniqueId, TraxRecord>,
        on_save: Box<dyn Fn(Vec<Record<TraxRecord>>)>,
        on_cancel: Box<dyn Fn()>,
    ) -> DayEdit {
        //let records: Arc<RwLock<Vec<Record<TraxRecord>>>> = Arc::new(RwLock::new(data.clone()));

        let widget = gtk::Box::new(gtk::Orientation::Vertical, 5);
        //let mut components = Vec::new();

        let first_row = gtk::Box::new(gtk::Orientation::Horizontal, 5);
        widget.pack_start(&first_row, false, false, 5);

        let mut weight_component = None;
        for (id, data) in data {
            match data {
                TraxRecord::Weight(ref rec) => {
                    weight_component = Some(weight_record_edit_c(
                        id.clone(),
                        &rec,
                        Box::new(|res| match res {
                            Ok(val) => println!("got a weight updated: {:?}", val),
                            Err(err) => println!("invalid weight field: {}", err),
                        }),
                    ))
                }
                _ => (),
            }
        }
        weight_component.map(|c| first_row.pack_start(&c.widget, false, false, 5));

        let buttons_row = gtk::Box::new(gtk::Orientation::Horizontal, 5);
        let save_button = gtk::Button::new_with_label("Save");
        let cancel_button = gtk::Button::new_with_label("Cancel");
        buttons_row.pack_start(&save_button, false, false, 5);
        buttons_row.pack_start(&cancel_button, false, false, 5);
        widget.pack_start(&buttons_row, true, true, 5);

        //let components_ = components.clone();
        save_button.connect_clicked(move |_| {
            /*
            let updated_records = components
                .iter()
                .map(|c| if c.is_updated() { Some(c) } else { None })
                .filter(|c| c.is_some())
                .map(|c| emseries::Record {
                    id: c.unwrap().id.clone(),
                    data: TraxRecord::from(c.unwrap().value()),
                })
                .collect();
            on_save(updated_records)
            */
        });
        cancel_button.connect_clicked(move |_| on_cancel());

        widget.show_all();

        DayEdit {
            widget,
            //components,
            //on_save,
            //on_cancel,
        }
    }

    fn show(&self) {
        self.widget.show_all();
    }
}
