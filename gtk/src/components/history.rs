use chrono::Date;
use chrono_tz::Tz;
use emseries::Record;
use fitnesstrax::TraxRecord;
use gtk::prelude::*;
use std::sync::{Arc, RwLock};

use crate::components::{Day, RangeSelector};
use crate::context::AppContext;
use crate::range::group_by_date;
use crate::types::DateRange;

pub struct History {
    pub widget: gtk::Box,
    range_bar: RangeSelector,
    scrolling_history: gtk::ScrolledWindow,
    history_box: gtk::Box,
    ctx: Arc<RwLock<AppContext>>,
}

impl History {
    pub fn new(ctx: Arc<RwLock<AppContext>>) -> History {
        let widget = gtk::Box::new(gtk::Orientation::Horizontal, 5);
        let history_box = gtk::Box::new(gtk::Orientation::Vertical, 5);

        let range_bar = {
            let ctx_ = ctx.clone();
            RangeSelector::new(
                ctx.read().unwrap().get_range().clone(),
                Box::new(move |new_range| ctx_.write().unwrap().set_range(new_range)),
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
            ctx,
        };

        w.update_from(
            w.ctx.read().unwrap().get_range(),
            w.ctx.read().unwrap().get_history().unwrap(),
        );

        w.show();

        w
    }

    pub fn update_from(&self, range: DateRange, history: Vec<Record<TraxRecord>>) {
        let grouped_history = group_by_date(range, history);

        self.history_box.foreach(|child| child.destroy());

        let mut dates = grouped_history.keys().collect::<Vec<&Date<Tz>>>();
        dates.sort_unstable();
        dates.reverse();
        dates.iter().for_each(|date| {
            let ctx = self.ctx.clone();
            let day = Day::new(
                (*date).clone(),
                grouped_history.get(date).unwrap().clone(),
                ctx,
            );
            day.show();
            self.history_box.pack_start(&day.widget, true, true, 25);
        });
    }

    pub fn show(&self) {
        self.widget.show();
        self.range_bar.show();
        self.scrolling_history.show();
        self.history_box.show_all();
    }
}
