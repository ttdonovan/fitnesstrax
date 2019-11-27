use gtk::prelude::*;
use std::sync::{Arc, RwLock};

use crate::context::AppContext;

pub struct RangeBar {
    ctx: Arc<RwLock<AppContext>>,
    widget: gtk::Box,
}

impl RangeBar {
    pub fn new(ctx: Arc<RwLock<AppContext>>) -> RangeBar {
        let widget = gtk::Box::new(gtk::Orientation::Vertical, 5);

        let range = ctx.read().unwrap().get_range();

        widget.pack_start(
            &gtk::Label::new(Some(&format!("{}", range.start.format("%B %e, %Y")))),
            false,
            false,
            5,
        );
        widget.pack_start(
            &gtk::Label::new(Some(&format!("{}", range.end.format("%B %e, %Y")))),
            false,
            false,
            5,
        );

        RangeBar { ctx, widget }
    }

    pub fn render(&self) -> &gtk::Box {
        &self.widget
    }
}
