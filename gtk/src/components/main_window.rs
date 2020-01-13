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

        let mut history = History::new(ctx.clone());
        let mut preferences = Preferences::new(ctx.clone());

        {
            let ctx = ctx.read().unwrap();
            notebook.append_page(
                history.render(
                    ctx.get_preferences(),
                    ctx.get_range(),
                    ctx.get_history().unwrap(),
                ),
                Some(&gtk::Label::new(Some("History"))),
            );
        }
        notebook.append_page(
            preferences.render(),
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
            Message::ChangeRange {
                prefs,
                range,
                records,
            } => {
                self.history.render(prefs, range, records);
            }
            Message::ChangePreferences(_) => (),
            Message::RecordsUpdated {
                prefs,
                range,
                records,
            } => {
                self.history.render(prefs, range, records);
            }
        }
    }

    pub fn show(&self) {
        self.notebook.show();
        self.widget.show();
    }
}
