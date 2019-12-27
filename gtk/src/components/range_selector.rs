use chrono_tz;
use gtk::prelude::*;
use std::sync::{Arc, RwLock};

use crate::components::DateSelector;
use crate::types::DateRange;

pub struct RangeSelector {
    pub widget: gtk::Box,
    start_selector: DateSelector,
    end_selector: DateSelector,
    on_change: Arc<RwLock<Option<Box<dyn Fn(DateRange)>>>>,
}

impl RangeSelector {
    pub fn new(range: DateRange, on_change: Option<Box<dyn Fn(DateRange)>>) -> RangeSelector {
        let start_date = range.start.clone();
        let end_date = range.end.clone();
        let on_change_arc = Arc::new(RwLock::new(on_change));
        let timezone = Arc::new(RwLock::new(range.start.timezone()));

        let range_arc = Arc::new(RwLock::new(range));
        let start_selector = {
            let range_ = range_arc.clone();
            let on_change_ = on_change_arc.clone();
            let timezone = timezone.clone();
            DateSelector::new(
                start_date,
                Some(Box::new(move |new_date| {
                    let new_range = DateRange {
                        start: new_date.with_timezone(&*timezone.read().unwrap()),
                        end: range_.read().unwrap().end.clone(),
                    };
                    *range_.write().unwrap() = new_range;
                    match *on_change_.read().unwrap() {
                        Some(ref change_handler_f) => {
                            (*change_handler_f)(range_.read().unwrap().clone())
                        }
                        None => (),
                    }
                })),
            )
        };

        let end_selector = {
            let range_ = range_arc.clone();
            let on_change_ = on_change_arc.clone();
            let timezone = timezone.clone();
            DateSelector::new(
                end_date,
                Some(Box::new(move |new_date| {
                    let new_range = DateRange {
                        start: range_.read().unwrap().start.clone(),
                        end: new_date.with_timezone(&*timezone.read().unwrap()),
                    };
                    *range_.write().unwrap() = new_range;
                    match *on_change_.read().unwrap() {
                        Some(ref change_handler_f) => {
                            (*change_handler_f)(range_.read().unwrap().clone())
                        }
                        None => (),
                    };
                })),
            )
        };

        let w = RangeSelector {
            widget: gtk::Box::new(gtk::Orientation::Vertical, 5),
            start_selector,
            end_selector,
            on_change: on_change_arc,
        };

        w.widget
            .pack_start(&w.start_selector.widget, false, false, 5);
        w.widget.pack_start(&w.end_selector.widget, false, false, 5);

        {}

        w
    }

    pub fn connect_change(&mut self, on_change: Box<dyn Fn(DateRange)>) {
        *self.on_change.write().unwrap() = Some(on_change);
    }

    pub fn update_from(&mut self, range: DateRange) {
        self.start_selector.update_from(range.start.clone());
        self.end_selector.update_from(range.end);
    }

    pub fn show(&self) {
        self.start_selector.show();
        self.end_selector.show();
        self.widget.show();
    }
}

fn dispatch_change(handler: &Arc<RwLock<Option<Box<dyn Fn(DateRange)>>>>, range: DateRange) {
    match *handler.read().unwrap() {
        Some(ref change_handler_f) => (*change_handler_f)(range),
        None => (),
    };
}
