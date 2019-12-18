use emseries::Record;
use fitnesstrax::TraxRecord;
use gtk::prelude::*;
use std::sync::{Arc, RwLock};

use crate::components::{day_c, RangeBar};
use crate::context::AppContext;
use crate::range::group_by_date;
use crate::types::DateRange;

pub struct History {
    pub widget: gtk::Box,
    range_bar: RangeBar,
    scrolling_history: gtk::ScrolledWindow,
    history_box: gtk::Box,
}

impl History {
    pub fn new(ctx: Arc<RwLock<AppContext>>) -> History {
        let widget = gtk::Box::new(gtk::Orientation::Horizontal, 5);
        let history_box = gtk::Box::new(gtk::Orientation::Vertical, 5);

        let range_bar = {
            let ctx_ = ctx.clone();
            RangeBar::new(
                ctx.read().unwrap().get_range().clone(),
                Some(Box::new(move |new_range| {
                    ctx_.write().unwrap().set_range(new_range)
                })),
            )
        };

        let no_adjustment: Option<&gtk::Adjustment> = None;
        let scrolling_history = gtk::ScrolledWindow::new(no_adjustment, no_adjustment);
        scrolling_history.add(&history_box);

        widget.pack_start(&range_bar.widget, false, false, 25);
        widget.pack_start(&scrolling_history, true, true, 5);

        let w = History {
            widget,
            range_bar,
            scrolling_history,
            history_box,
        };

        w.update_from(
            ctx.read().unwrap().get_range(),
            ctx.read().unwrap().get_history().unwrap(),
        );

        w.show();

        w
    }

    pub fn update_from(&self, range: DateRange, history: Vec<Record<TraxRecord>>) {
        let grouped_history = group_by_date(range, history);

        self.history_box.foreach(|child| child.destroy());

        let dates = grouped_history.keys();
        dates.for_each(|date| {
            println!("populating {:?}", date);
            let day = day_c(date, grouped_history.get(date).unwrap());
            day.show_all();
            self.history_box.pack_start(&day, true, true, 25);
        });
    }

    pub fn show(&self) {
        self.widget.show();
        self.range_bar.show();
        self.scrolling_history.show();
        self.history_box.show_all();
    }
}
