use crate::context::{AppContext, Message};
use emseries::Record;
use fitnesstrax::TraxRecord;
use gtk::prelude::*;
use std::sync::{Arc, RwLock};

use crate::components::*;
use crate::i18n::Messages;
use crate::preferences;
use crate::types::DateRange;

struct MainWindowComponent {
    notebook: gtk::Notebook,
    history_label: gtk::Label,
    preferences_label: gtk::Label,
    history: History,
    preferences: Preferences,
}

pub struct MainWindow {
    widget: gtk::ApplicationWindow,
    component: Option<MainWindowComponent>,
    ctx: Arc<RwLock<AppContext>>,
}

impl MainWindow {
    pub fn new(ctx: Arc<RwLock<AppContext>>, app: &gtk::Application) -> MainWindow {
        let widget = gtk::ApplicationWindow::new(app);
        widget.set_title("Fitnesstrax");
        widget.set_default_size(350, 70);

        MainWindow {
            widget,
            component: None,
            ctx,
        }
    }

    pub fn render(
        &mut self,
        messages: Messages,
        prefs: preferences::Preferences,
        range: DateRange,
        records: Vec<Record<TraxRecord>>,
    ) -> &gtk::ApplicationWindow {
        match self.component {
            None => {
                let notebook = gtk::Notebook::new();
                let mut history = History::new(self.ctx.clone());
                let mut preferences = Preferences::new(self.ctx.clone());

                let ctx = self.ctx.read().unwrap();
                let messages = ctx.get_messages();
                let history_label = gtk::Label::new(Some(&messages.history()));
                let preferences_label = gtk::Label::new(Some(&messages.preferences()));

                notebook.append_page(
                    history.render(
                        ctx.get_preferences(),
                        ctx.get_range(),
                        ctx.get_history().unwrap(),
                    ),
                    Some(&history_label),
                );
                notebook.append_page(preferences.render(), Some(&preferences_label));

                notebook.show();
                self.widget.add(&notebook);
                self.widget.show();

                let component = MainWindowComponent {
                    notebook,
                    history_label,
                    preferences_label,
                    history,
                    preferences,
                };
                self.component = Some(component);
            }
            Some(MainWindowComponent {
                ref history_label,
                ref preferences_label,
                ref mut history,
                ref mut preferences,
                ..
            }) => {
                history_label.set_markup(&messages.history());
                preferences_label.set_markup(&messages.preferences());
                history.render(prefs, range, records);
                preferences.render();
            }
        }
        &self.widget
    }

    pub fn update_from(&mut self, message: Message) {
        match message {
            Message::ChangeRange {
                prefs,
                messages,
                range,
                records,
            } => {
                self.render(messages, prefs, range, records);
            }
            Message::ChangePreferences {
                prefs,
                messages,
                range,
                records,
            } => {
                self.render(messages, prefs, range, records);
            }
            Message::RecordsUpdated {
                prefs,
                messages,
                range,
                records,
            } => {
                self.render(messages, prefs, range, records);
            }
        }
    }

    /*
    pub fn show(&self) {
        self.notebook.show();
        self.widget.show();
    }
    */
}
