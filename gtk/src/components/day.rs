//use chrono_tz::Tz;
use dimensioned::si::KG;
use emseries::{DateTimeTz, Record, Recordable, UniqueId};
use fitnesstrax::steps::StepRecord;
use fitnesstrax::weight::WeightRecord;
use fitnesstrax::TraxRecord;
use gtk::prelude::*;
use std::collections::HashMap;
use std::sync::{Arc, RwLock};
use std::thread;

use crate::components::basics::date_c;
use crate::components::rep_duration::rep_duration_c;
use crate::components::set_rep::set_rep_c;
use crate::components::steps::{steps_c, steps_edit_c};
use crate::components::time_distance::TimeDistanceEdit;
use crate::components::time_distance_row::time_distance_c;
use crate::components::weight::{weight_record_c, weight_record_edit_c};
use crate::components::{Component, SwappableComponent};
use crate::context::AppContext;
use crate::i18n::UnitSystem;
use crate::settings::Settings;

#[derive(Clone)]
enum DayState {
    View(gtk::Box),
    Edit(DayEdit),
}

impl Component for DayState {
    fn render(&self) -> gtk::Box {
        match self {
            DayState::View(b) => b.render(),
            DayState::Edit(e) => e.render(),
        }
    }
}

struct SwappableDay {
    component: SwappableComponent,
    state: DayState,

    date: chrono::Date<chrono_tz::Tz>,
    records: Vec<Record<TraxRecord>>,
    settings: Settings,
}

impl SwappableDay {
    fn new(
        date: chrono::Date<chrono_tz::Tz>,
        records: Vec<Record<TraxRecord>>,
        settings: Settings,
    ) -> SwappableDay {
        let default_view = DayState::View(gtk::Box::new(gtk::Orientation::Vertical, 5));

        let mut s = SwappableDay {
            state: default_view.clone(),
            component: SwappableComponent::new(Box::new(default_view)),

            date,
            records,
            settings,
        };
        s.view();
        s
    }

    pub fn set_records(
        &mut self,
        date: chrono::Date<chrono_tz::Tz>,
        records: Vec<Record<TraxRecord>>,
    ) {
        self.date = date;
        self.records = records;
        match self.state {
            DayState::View(_) => self.view(),
            DayState::Edit(ref e) => {}
        }
    }

    /*
    pub fn set_messages(&mut self, messages: Messages) {
        self.messages = messages;
        match self.state {
            DayState::View(_) => self.view(),
            DayState::Edit(ref e) => {}
        }
    }

    pub fn set_preferences(&mut self, prefs: Preferences) {
        self.prefs = prefs;
        match self.state {
            DayState::View(_) => self.view(),
            DayState::Edit(ref e) => {}
        }
    }
    */

    fn view(&mut self) {
        let v = day_c(
            &self.date,
            self.records.iter().map(|rec| &rec.data).collect(),
            &self.settings,
        );
        self.state = DayState::View(v);
        self.component.swap(Box::new(self.state.clone()));
    }

    fn edit(
        &mut self,
        on_save: Box<dyn Fn(Vec<(UniqueId, TraxRecord)>, Vec<TraxRecord>)>,
        on_cancel: Box<dyn Fn()>,
    ) {
        let record_map = self.records.iter().fold(HashMap::new(), |mut acc, rec| {
            acc.insert(rec.id.clone(), rec.data.clone());
            acc
        });
        self.state = DayState::Edit(DayEdit::new(
            &self.date,
            &record_map,
            &self.settings,
            on_save,
            on_cancel,
        ));
        self.component.swap(Box::new(self.state.clone()));
    }
}

impl Component for SwappableDay {
    fn render(&self) -> gtk::Box {
        self.component.render()
    }
}

#[derive(Clone)]
pub struct Day {
    widget: gtk::Box,
    edit_button: gtk::Button,
    swappable: Arc<RwLock<SwappableDay>>,
    ctx: Arc<RwLock<AppContext>>,
}

impl Component for Day {
    fn render(&self) -> gtk::Box {
        self.widget.clone()
    }
}

impl Day {
    pub fn new(
        ctx: Arc<RwLock<AppContext>>,
        date: chrono::Date<chrono_tz::Tz>,
        records: Vec<Record<TraxRecord>>,
        settings: Settings,
    ) -> Day {
        let widget = gtk::Box::new(gtk::Orientation::Vertical, 5);
        let header = gtk::Box::new(gtk::Orientation::Horizontal, 5);
        let edit_button = gtk::Button::new_with_label(&settings.text.edit());
        edit_button.show();

        header.pack_start(&date_c(&date), false, false, 5);
        header.pack_start(&edit_button, false, false, 5);
        header.show();
        widget.pack_start(&header, false, false, 5);

        let swappable = SwappableDay::new(date, records, settings);

        widget.pack_start(&swappable.render(), true, true, 5);

        widget.show();

        let c = Day {
            widget,
            edit_button,
            swappable: Arc::new(RwLock::new(swappable)),
            ctx,
        };

        {
            let c_ = c.clone();
            c.edit_button.connect_clicked(move |_| c_.edit());
        }

        c.view();
        c
    }

    fn set_records(&mut self, date: chrono::Date<chrono_tz::Tz>, records: Vec<Record<TraxRecord>>) {
        self.swappable.write().unwrap().set_records(date, records);
    }

    /*
    fn set_messages(&mut self, messages: Messages) {
        self.swappable.write().unwrap().set_messages(messages);
    }

    fn set_preferences(&mut self, prefs: Preferences) {
        self.swappable.write().unwrap().set_preferences(prefs);
    }
    */

    fn view(&self) {
        let mut c = self.swappable.write().unwrap();

        c.view();
    }

    fn edit(&self) {
        let mut c = self.swappable.write().unwrap();

        let self_save = self.clone();
        let self_cancel = self.clone();
        c.edit(
            Box::new(move |updated_records, new_records| {
                self_save.save(updated_records, new_records)
            }),
            Box::new(move || self_cancel.view()),
        );
    }

    fn save(&self, updated_records: Vec<(UniqueId, TraxRecord)>, new_records: Vec<TraxRecord>) {
        let ctx = self.ctx.clone();
        thread::spawn(move || {
            ctx.write()
                .unwrap()
                .save_records(updated_records, new_records);
        });
        self.view();
    }
}

fn day_c(
    _date: &chrono::Date<chrono_tz::Tz>,
    data: Vec<&TraxRecord>,
    settings: &Settings,
) -> gtk::Box {
    let container = gtk::Box::new(gtk::Orientation::Vertical, 5);

    let first_row = gtk::Box::new(gtk::Orientation::Horizontal, 5);
    container.pack_start(&first_row, false, false, 5);

    let mut weight_component = None;
    let mut step_component = None;
    let mut rep_duration_components: Vec<gtk::Box> = Vec::new();
    let mut set_rep_components: Vec<gtk::Box> = Vec::new();
    let mut time_distance_components: Vec<gtk::Box> = Vec::new();
    let mut records = data.clone();
    records.sort_unstable_by_key(|rec| rec.timestamp());
    for record in records {
        match record {
            TraxRecord::Comments(ref _rec) => (),
            TraxRecord::RepDuration(ref rec) => {
                rep_duration_components.push(rep_duration_c(&rec, &settings))
            }
            TraxRecord::SetRep(ref rec) => set_rep_components.push(set_rep_c(&rec, &settings)),
            TraxRecord::Steps(ref rec) => step_component = Some(steps_c(&rec, &settings)),
            TraxRecord::TimeDistance(ref rec) => {
                time_distance_components.push(time_distance_c(&rec, &settings))
            }
            TraxRecord::Weight(ref rec) => {
                weight_component = Some(weight_record_c(&rec, &settings))
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

#[derive(Clone)]
struct DayEdit {
    widget: gtk::Box,
}

impl Component for DayEdit {
    fn render(&self) -> gtk::Box {
        self.widget.clone()
    }
}

impl DayEdit {
    fn new(
        date: &chrono::Date<chrono_tz::Tz>,
        data: &HashMap<UniqueId, TraxRecord>,
        settings: &Settings,
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
                &settings.units,
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

        let mut time_distance_records = Vec::new();

        for (id, data) in data {
            match data {
                TraxRecord::Weight(ref rec) => {
                    let updates_ = updates.clone();
                    weight_component = weight_record_edit_c(
                        id.clone(),
                        rec.clone(),
                        &settings.units,
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
                    time_distance_records.push((id, rec));
                }
                _ => (),
            }
        }

        let time_distance_edit =
            { TimeDistanceEdit::new(date.clone(), time_distance_records, settings.clone()) };

        let weight_label = match settings.units {
            UnitSystem::SI => "kg",
            UnitSystem::USA => "lbs",
        };

        first_row.pack_start(&weight_component, false, false, 5);
        first_row.pack_start(&gtk::Label::new(Some(weight_label)), false, false, 5);
        first_row.pack_start(&step_component, false, false, 5);
        first_row.pack_start(&gtk::Label::new(Some("steps")), false, false, 5);
        widget.pack_start(&time_distance_edit.widget, false, false, 5);

        let buttons_row = gtk::Box::new(gtk::Orientation::Horizontal, 5);
        let save_button = gtk::Button::new_with_label(&settings.text.save());
        let cancel_button = gtk::Button::new_with_label(&settings.text.cancel());
        buttons_row.pack_start(&save_button, false, false, 5);
        buttons_row.pack_start(&cancel_button, false, false, 5);
        widget.pack_start(&buttons_row, false, false, 5);

        {
            let updates = updates.clone();
            let new_records = new_records.clone();
            save_button.connect_clicked(move |_| {
                let mut updated_records: Vec<(UniqueId, TraxRecord)> = updates
                    .read()
                    .unwrap()
                    .iter()
                    .map(|(id, record)| (id.clone(), record.clone()))
                    .collect();
                let mut new_records_: Vec<TraxRecord> = new_records
                    .read()
                    .unwrap()
                    .values()
                    .map(|v| v.clone())
                    .collect();

                updated_records.append(
                    &mut time_distance_edit
                        .updated_records()
                        .into_iter()
                        .map(|(id, rec)| (id, TraxRecord::from(rec)))
                        .collect::<Vec<(UniqueId, TraxRecord)>>(),
                );

                new_records_.append(
                    &mut time_distance_edit
                        .new_records()
                        .into_iter()
                        .map(|(_, rec)| TraxRecord::from(rec))
                        .collect::<Vec<TraxRecord>>(),
                );

                on_save(updated_records, new_records_);
            });
        }
        cancel_button.connect_clicked(move |_| on_cancel());

        widget.show_all();

        DayEdit { widget }
    }
}
