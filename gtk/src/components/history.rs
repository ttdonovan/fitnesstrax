use gtk::prelude::*;
use std::sync::{Arc, RwLock};

use super::{day_c, RangeBar};
use crate::context::{AppContext, Message};
use crate::range::group_by_date;

pub struct History {
    widget: gtk::Box,
    range_bar: RangeBar,
    scrolling_history: gtk::ScrolledWindow,
    history_box: gtk::Box,
}

impl History {
    pub fn new(ctx: Arc<RwLock<AppContext>>) -> History {
        let widget = gtk::Box::new(gtk::Orientation::Horizontal, 5);
        let history_box = gtk::Box::new(gtk::Orientation::Vertical, 5);

        let range_bar = RangeBar::new(ctx.clone());

        let no_adjustment: Option<&gtk::Adjustment> = None;
        let scrolling_history = gtk::ScrolledWindow::new(no_adjustment, no_adjustment);
        scrolling_history.add(&history_box);
        scrolling_history.show();

        widget.pack_start(range_bar.render(), false, false, 25);
        widget.pack_start(&scrolling_history, true, true, 5);

        let history = group_by_date(
            ctx.read().unwrap().get_range(),
            ctx.read().unwrap().get_history().unwrap(),
        );

        let dates = history.keys();
        dates.for_each(|date| {
            let day = day_c(date, history.get(date).unwrap());
            day.show_all();
            history_box.pack_start(&day, true, true, 25);
        });

        ctx.write().unwrap().register_listener(Box::new(|message| {
            println!("Message received: {:?}", message)
        }));

        History {
            widget,
            range_bar,
            scrolling_history,
            history_box,
        }
    }

    /*
    fn range_update(&self, new_range: &DateRange) {
        println!("{:?}", new_range);
    }
    */

    pub fn show(&self) {
        self.widget.show();
        self.range_bar.show();
        self.history_box.show();
    }

    pub fn render(&self) -> &gtk::Box {
        &self.widget
    }
}
