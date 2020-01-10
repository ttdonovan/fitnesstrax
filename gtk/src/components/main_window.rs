use crate::context::{AppContext, Message};
use gtk::prelude::*;
use std::sync::{Arc, RwLock};

use crate::components::*;

pub struct MainWindow {
    pub widget: gtk::ApplicationWindow,
    notebook: gtk::Notebook,
    history: History,
    preferences: Preferences,
}

impl MainWindow {
    pub fn new(ctx: Arc<RwLock<AppContext>>, app: &gtk::Application) -> MainWindow {
        let widget = gtk::ApplicationWindow::new(app);
        let notebook = gtk::Notebook::new();

        let history = History::new(ctx.clone());
        let preferences = Preferences::new(ctx.clone());

        notebook.append_page(&history.widget, Some(&gtk::Label::new(Some("History"))));
        notebook.append_page(
            &preferences.widget,
            Some(&gtk::Label::new(Some("Preferences"))),
        );

        let w = MainWindow {
            widget,
            notebook,
            history,
            preferences,
        };

        w.widget.set_title("Fitnesstrax");
        w.widget.set_default_size(350, 70);

        w.widget.add(&w.notebook);
        w.show();

        w
    }

    pub fn update_from(&mut self, message: Message) {
        match message {
            Message::ChangeRange { range, records } => self.history.update_from(range, records),
            Message::ChangeLanguage(_) => (),
            Message::ChangeTimezone(_) => (),
            Message::ChangeUnits(_) => (),
            Message::RecordsUpdated { range, records } => self.history.update_from(range, records),
        }
    }

    pub fn show(&self) {
        self.notebook.show();
        self.widget.show();
    }
}
