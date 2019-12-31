use chrono_tz;
use gtk::prelude::*;
use std::sync::{Arc, RwLock};

use crate::components::DateSelector;
use crate::types::DateRange;

pub struct RangeSelector {
    pub widget: gtk::Box,
    start_selector: DateSelector,
    end_selector: DateSelector,
    on_change: Arc<Box<dyn Fn(DateRange)>>,
}

impl RangeSelector {
    pub fn new(range: DateRange, on_change: Box<dyn Fn(DateRange)>) -> RangeSelector {
        let start_date = range.start.clone();
        let end_date = range.end.clone();
        let on_change = Arc::new(on_change);
        let timezone = Arc::new(RwLock::new(range.start.timezone()));

        let range = Arc::new(RwLock::new(range));
        let start_selector = {
            let range = range.clone();
            let on_change = on_change.clone();
            let timezone = timezone.clone();
            DateSelector::new(
                start_date,
                Box::new(move |new_date| {
                    let mut r = range.write().unwrap();
                    let new_range = DateRange {
                        start: new_date.with_timezone(&*timezone.read().unwrap()),
                        end: r.end.clone(),
                    };
                    *r = new_range;
                    on_change(r.clone());
                }),
            )
        };

        let end_selector = {
            let range = range.clone();
            let on_change = on_change.clone();
            let timezone = timezone.clone();
            DateSelector::new(
                end_date,
                Box::new(move |new_date| {
                    let mut r = range.write().unwrap();
                    let new_range = DateRange {
                        start: r.start.clone(),
                        end: new_date.with_timezone(&*timezone.read().unwrap()),
                    };
                    *r = new_range;
                    on_change(r.clone());
                }),
            )
        };

        let w = RangeSelector {
            widget: gtk::Box::new(gtk::Orientation::Vertical, 5),
            start_selector,
            end_selector,
            on_change: on_change,
        };

        w.widget
            .pack_start(&w.start_selector.widget, false, false, 5);
        w.widget.pack_start(&w.end_selector.widget, false, false, 5);

        {}

        w
    }

    /*
    pub fn connect_change(&mut self, on_change: Box<dyn Fn(DateRange)>) {
        *self.on_change.write().unwrap() = Some(on_change);
    }
    */

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
