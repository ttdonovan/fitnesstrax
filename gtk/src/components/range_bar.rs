use gtk::prelude::*;
use std::sync::Arc;

use crate::components::DateSelector;
use crate::types::DateRange;

pub struct RangeBar {
    start_selector: DateSelector,
    end_selector: DateSelector,
    range: DateRange,
    on_change: Option<Box<dyn Fn(DateRange)>>,
}

impl RangeBar {
    pub fn new(range: DateRange) -> RangeBar {
        let start_date = range.start.clone();
        let end_date = range.end.clone();

        let start_selector = DateSelector::new(range.start.clone());

        let end_selector = DateSelector::new(range.end.clone());

        let mut s = RangeBar {
            start_selector,
            end_selector,
            range,
            on_change: None,
        };

        s.start_selector.connect_change(Box::new(move |new_date| {
            println!("new start date: {:?}", new_date);
            s.on_change.map(|f| {
                f(DateRange {
                    start: new_date,
                    end: s.range.end,
                })
            });
        }));

        s
    }

    /*
    pub fn update_from(&mut self, range: DateRange) {
        self.start_time.update_from(range.start.clone());
        self.end_time.update_from(range.end);
    }
    */

    //pub fn set_handler(&mut self,

    pub fn render(&self) -> gtk::Box {
        let widget = gtk::Box::new(gtk::Orientation::Vertical, 5);
        widget.pack_start(&self.start_selector.render(), false, false, 5);
        widget.pack_start(&self.end_selector.render(), false, false, 5);

        widget
    }
}
