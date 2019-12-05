use gtk::prelude::*;
use std::sync::{Arc, RwLock};

use super::DateSelector;
use crate::context::AppContext;
use crate::range::Range;

pub struct RangeBar {
    ctx: Arc<RwLock<AppContext>>,
    widget: gtk::Box,
    start_time: DateSelector,
    end_time: DateSelector,
}

impl RangeBar {
    pub fn new(ctx: Arc<RwLock<AppContext>>) -> RangeBar {
        let widget = gtk::Box::new(gtk::Orientation::Vertical, 5);

        let range = ctx.read().unwrap().get_range();

        let ctx_start_clone = ctx.clone();
        let start_time = DateSelector::new(
            range.start.clone(),
            Box::new(move |new_date| {
                let mut ctx_ref = ctx_start_clone.write().unwrap();
                let range = ctx_ref.get_range();
                ctx_ref.set_range(Range {
                    start: new_date,
                    end: range.end,
                })
            }),
        );

        let ctx_end_clone = ctx.clone();
        let end_time = DateSelector::new(
            range.end.clone(),
            Box::new(move |new_date| {
                let mut ctx_ref = ctx_end_clone.write().unwrap();
                let range = ctx_ref.get_range();
                ctx_ref.set_range(Range {
                    start: range.start,
                    end: new_date,
                })
            }),
        );

        widget.pack_start(start_time.render(), false, false, 5);
        widget.pack_start(end_time.render(), false, false, 5);

        RangeBar {
            ctx,
            widget,
            start_time,
            end_time,
        }
    }

    pub fn show(&self) {
        self.widget.show();
        self.start_time.show();
        self.end_time.show();
    }

    pub fn render(&self) -> &gtk::Box {
        &self.widget
    }
}
