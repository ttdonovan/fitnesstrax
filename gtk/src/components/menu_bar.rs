use gtk::prelude::*;

use crate::i18n::Messages;

pub struct MenuBar {
    pub widget: gtk::Box,
}

impl MenuBar {
    pub fn new(messages: &Messages) -> MenuBar {
        let widget = gtk::Box::new(gtk::Orientation::Horizontal, 5);

        widget.pack_start(
            &gtk::Label::new(messages.tr("history").as_ref().map(|c| &**c)),
            false,
            false,
            50,
        );
        widget.pack_start(
            &gtk::Label::new(messages.tr("preferences").as_ref().map(|c| &**c)),
            false,
            false,
            50,
        );

        MenuBar { widget }
    }

    pub fn show(&self) {
        self.widget.show_all();
    }
}
