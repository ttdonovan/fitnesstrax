use gtk::prelude::*;
use std::sync::{Arc, RwLock};

use crate::context::AppContext;

pub struct MenuBar {
    pub widget: gtk::Box,
}

impl MenuBar {
    pub fn new() -> MenuBar {
        let widget = gtk::Box::new(gtk::Orientation::Horizontal, 5);

        widget.pack_start(&gtk::Label::new(Some("History")), false, false, 50);
        widget.pack_start(&gtk::Label::new(Some("Settings")), false, false, 50);

        MenuBar { widget }
    }

    pub fn show(&self) {
        self.widget.show_all();
    }
}
