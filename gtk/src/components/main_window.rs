use crate::context::{AppContext, Message};
use emseries::Record;
use fitnesstrax::TraxRecord;
use gtk::prelude::*;
use std::sync::{Arc, RwLock};

use crate::components::*;
use crate::settings::Settings;
use crate::types::DateRange;

struct MainWindowComponent {
    notebook: gtk::Notebook,
    history_label: gtk::Label,
    settings_label: gtk::Label,
    history: History,
    settings_ui: Preferences,
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
        settings: Settings,
        range: DateRange,
        records: Vec<Record<TraxRecord>>,
    ) -> &gtk::ApplicationWindow {
        match self.component {
            None => {
                let notebook = gtk::Notebook::new();
                let mut history = History::new(self.ctx.clone());
                let mut settings_ui = Preferences::new(self.ctx.clone());

                let ctx = self.ctx.read().unwrap();
                let history_label = gtk::Label::new(Some(&settings.text.history()));
                let settings_label = gtk::Label::new(Some(&settings.text.preferences()));

                notebook.append_page(
                    history.render(settings, range, records),
                    Some(&history_label),
                );
                notebook.append_page(settings_ui.render(), Some(&settings_label));

                notebook.show();
                self.widget.add(&notebook);
                self.widget.show();

                let component = MainWindowComponent {
                    notebook,
                    history_label,
                    settings_label,
                    history,
                    settings_ui,
                };
                self.component = Some(component);
            }
            Some(MainWindowComponent {
                ref history_label,
                ref settings_label,
                ref mut history,
                ref mut settings_ui,
                ..
            }) => {
                history_label.set_markup(&settings.text.history());
                settings_label.set_markup(&settings.text.preferences());
                history.render(settings, range, records);
                settings_ui.render();
            }
        }
        &self.widget
    }

    pub fn update_from(&mut self, message: Message) {
        match message {
            Message::ChangeRange {
                settings,
                range,
                records,
            } => {
                self.render(settings, range, records);
            }
            Message::ChangeSettings {
                settings,
                range,
                records,
            } => {
                self.render(settings, range, records);
            }
            Message::RecordsUpdated {
                settings,
                range,
                records,
            } => {
                self.render(settings, range, records);
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
