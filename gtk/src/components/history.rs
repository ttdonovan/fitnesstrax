use emseries::Record;
use fitnesstrax::TraxRecord;
use gtk::prelude::*;

use super::{day_c, RangeBar};
use crate::context::AppContext;
use crate::range::group_by_date;

pub struct HistoryHandlers {
    range_change: Option<Box<dyn Fn(DateRange)>>,
}

impl Default for HistoryHandlers {
    fn default() -> HistoryHandlers {
        HistoryHandlers { range_change: None }
    }
}

pub struct History {
    pub widget: gtk::Box,
    range_bar: RangeBar,
    scrolling_history: gtk::ScrolledWindow,
    history_box: gtk::Box,

    handlers: HistoryHandlers,
}

impl History {
    pub fn new(ctx: &AppContext) -> History {
        let widget = gtk::Box::new(gtk::Orientation::Horizontal, 5);
        let history_box = gtk::Box::new(gtk::Orientation::Vertical, 5);

        let range_bar = RangeBar::new(ctx.get_range());

        let no_adjustment: Option<&gtk::Adjustment> = None;
        let scrolling_history = gtk::ScrolledWindow::new(no_adjustment, no_adjustment);
        scrolling_history.add(&history_box);
        //scrolling_history.show();

        widget.pack_start(range_bar.render(), false, false, 25);
        widget.pack_start(&scrolling_history, true, true, 5);

        let s = History {
            widget,
            range_bar,
            scrolling_history,
            history_box,

            handlers: Default::default(),
        };

        s.update_from(ctx);

        s
    }

    pub fn update_from(&self, ctx: &AppContext) {
        let range = ctx.get_range();
        let history = ctx.get_history().unwrap();

        println!("update_from: {:?}", range);
        println!("update_from: {:?}", history);

        let grouped_history = group_by_date(range, history);

        self.history_box.foreach(|child| child.destroy());

        let dates = grouped_history.keys();
        dates.for_each(|date| {
            let day = day_c(date, grouped_history.get(date).unwrap());
            //day.show_all();
            self.history_box.pack_start(&day, true, true, 25);
        });
    }

    pub fn show(&self) {
        println!("showing history");
        //self.widget.show();
        //self.range_bar.show();
        //self.history_box.show_all();
    }

    /*
    pub fn render(&self) -> &gtk::Box {
        let ctx_ = self.ctx.write().unwrap();
        self.display_history(ctx_.get_range(), ctx_.get_history().unwrap());

        ctx_.register_listener(|msg| self.process_message(msg));

        &self.widget
    }
    */
}
