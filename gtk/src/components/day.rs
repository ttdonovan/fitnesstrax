use chrono::Utc;
use dimensioned::si::KG;
use emseries::{DateTimeTz, Record, UniqueId};
use fitnesstrax::steps::StepRecord;
use fitnesstrax::timedistance;
use fitnesstrax::weight::WeightRecord;
use fitnesstrax::TraxRecord;
use gtk::prelude::*;
use std::collections::HashMap;
use std::sync::{Arc, RwLock};

use crate::components::basics::date_c;
use crate::components::rep_duration::rep_duration_c;
use crate::components::set_rep::set_rep_c;
use crate::components::steps::{steps_c, steps_edit_c};
use crate::components::time_distance::{time_distance_c, time_distance_record_edit_c};
use crate::components::weight::{weight_record_c, weight_record_edit_c};
use crate::context::AppContext;

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
    ctx: Arc<RwLock<AppContext>>,
}

impl Day {
    pub fn new(
        date: chrono::Date<chrono_tz::Tz>,
        records: Vec<Record<TraxRecord>>,
        ctx: Arc<RwLock<AppContext>>,
    ) -> Day {
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
            ctx,
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
            &self.ctx.read().unwrap().get_timezone(),
            Box::new(move |updated_records, new_records| {
                self_save.save_edit(updated_records, new_records)
            }),
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

    fn save_edit(
        &self,
        updated_records: Vec<(UniqueId, TraxRecord)>,
        new_records: Vec<TraxRecord>,
    ) {
        self.ctx
            .write()
            .unwrap()
            .save_records(updated_records, new_records);
        self.cancel_edit();
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
}

impl DayEdit {
    fn new(
        date: &chrono::Date<chrono_tz::Tz>,
        data: &HashMap<UniqueId, TraxRecord>,
        timezone: &chrono_tz::Tz,
        on_save: Box<dyn Fn(Vec<(UniqueId, TraxRecord)>, Vec<TraxRecord>)>,
        on_cancel: Box<dyn Fn()>,
    ) -> DayEdit {
        let updates = Arc::new(RwLock::new(HashMap::new()));
        let new_records = Arc::new(RwLock::new(HashMap::new()));

        let widget = gtk::Box::new(gtk::Orientation::Vertical, 5);

        let first_row = gtk::Box::new(gtk::Orientation::Horizontal, 5);
        widget.pack_start(&first_row, false, false, 5);

        let mut weight_component = {
            let date_ = date.clone();
            let new_records_ = new_records.clone();
            weight_record_edit_c(
                UniqueId::new(),
                WeightRecord::new(DateTimeTz(date_.and_hms(0, 0, 0)), 0.0 * KG),
                Box::new(move |id, rec| {
                    new_records_
                        .write()
                        .unwrap()
                        .insert(id, TraxRecord::from(rec));
                }),
            )
        };

        let mut step_component = {
            let date_ = date.clone();
            let new_records_ = new_records.clone();
            steps_edit_c(
                UniqueId::new(),
                StepRecord::new(DateTimeTz(date_.and_hms(0, 0, 0)), 0),
                Box::new(move |id, rec| {
                    new_records_
                        .write()
                        .unwrap()
                        .insert(id, TraxRecord::from(rec));
                }),
            )
        };

        let mut time_distance_components = Vec::new();

        for (id, data) in data {
            match data {
                TraxRecord::Weight(ref rec) => {
                    let updates_ = updates.clone();
                    weight_component = weight_record_edit_c(
                        id.clone(),
                        rec.clone(),
                        Box::new(move |id, rec| {
                            updates_.write().unwrap().insert(id, TraxRecord::from(rec));
                        }),
                    )
                }
                TraxRecord::Steps(ref rec) => {
                    let updates_ = updates.clone();
                    step_component = steps_edit_c(
                        id.clone(),
                        rec.clone(),
                        Box::new(move |id_, rec| {
                            updates_
                                .write()
                                .unwrap()
                                .insert(id_.clone(), TraxRecord::from(rec));
                        }),
                    )
                }
                TraxRecord::TimeDistance(ref rec) => {
                    let updates_ = updates.clone();
                    time_distance_components.push(time_distance_record_edit_c(
                        id.clone(),
                        rec.clone(),
                        Box::new(move |id_, rec| {
                            updates_
                                .write()
                                .unwrap()
                                .insert(id_.clone(), TraxRecord::from(rec));
                        }),
                    ));
                }
                _ => (),
            }
        }

        {
            let new_records_ = new_records.clone();
            time_distance_components.push(time_distance_record_edit_c(
                UniqueId::new(),
                timedistance::TimeDistanceRecord::new(
                    DateTimeTz(Utc::now().with_timezone(timezone)),
                    timedistance::ActivityType::Cycling,
                    None,
                    None,
                    None,
                ),
                Box::new(move |id_, rec| {
                    new_records_
                        .write()
                        .unwrap()
                        .insert(id_, TraxRecord::from(rec));
                }),
            ));
        }

        first_row.pack_start(&weight_component.widget, false, false, 5);
        first_row.pack_start(&gtk::Label::new(Some("kg")), false, false, 5);
        first_row.pack_start(&step_component.widget, false, false, 5);
        first_row.pack_start(&gtk::Label::new(Some("steps")), false, false, 5);
        for component in time_distance_components {
            widget.pack_start(&component, false, false, 5);
        }

        let buttons_row = gtk::Box::new(gtk::Orientation::Horizontal, 5);
        let save_button = gtk::Button::new_with_label("Save");
        let cancel_button = gtk::Button::new_with_label("Cancel");
        buttons_row.pack_start(&save_button, false, false, 5);
        buttons_row.pack_start(&cancel_button, false, false, 5);
        widget.pack_start(&buttons_row, true, true, 5);

        {
            let updates_ = updates.clone();
            save_button.connect_clicked(move |_| {
                let updated_records = updates_
                    .read()
                    .unwrap()
                    .iter()
                    .map(|(id, record)| (id.clone(), record.clone()))
                    .collect();
                let new_records_: Vec<TraxRecord> = new_records
                    .read()
                    .unwrap()
                    .values()
                    .map(|v| v.clone())
                    .collect();
                on_save(updated_records, new_records_);
            });
        }
        cancel_button.connect_clicked(move |_| on_cancel());

        widget.show_all();

        DayEdit { widget }
    }

    fn show(&self) {
        self.widget.show_all();
    }
}
