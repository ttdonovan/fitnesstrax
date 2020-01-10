use gtk::prelude::*;
use std::sync::{Arc, RwLock};


pub struct Preferences {
    pub widget: gtk::Box,
}

impl Preferences {
    pub fn new() -> Preferences {
        let widget = gtk::Box::new(gtk::Orientation::Vertical, 5);

        let w = Preferences { widget };

        w.show();

        w
    }

    pub fn show(&self) {
        self.widget.show();
    }
}
