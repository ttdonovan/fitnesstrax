use crate::context::{AppContext, Message};
use gtk::prelude::*;
use std::sync::{Arc, RwLock};

use crate::components::*;

pub struct MainWindow {
    pub widget: gtk::ApplicationWindow,
    menubar: MenuBar,
    history: History,
}

impl MainWindow {
    pub fn new(ctx: Arc<RwLock<AppContext>>, app: &gtk::Application) -> MainWindow {
        let widget = gtk::ApplicationWindow::new(app);
        let menubar = MenuBar::new();
        let history = History::new(ctx.clone());

        let w = MainWindow {
            widget,
            menubar,
            history,
        };

        w.widget.set_title("Fitnesstrax");
        w.widget.set_default_size(350, 70);

        let main_panel = gtk::Box::new(gtk::Orientation::Vertical, 5);
        main_panel.pack_start(&w.menubar.widget, false, false, 5);
        main_panel.pack_start(&w.history.widget, true, true, 5);
        w.widget.add(&main_panel);
        main_panel.show();
        w.show();

        w
    }

    pub fn update_from(&mut self, message: Message) {
        match message {
            Message::ChangeRange { range, records } => self.history.update_from(range, records),
            Message::RecordsUpdated { range, records } => self.history.update_from(range, records),
        }
    }

    pub fn show(&self) {
        self.menubar.show();
        self.history.show();
        self.widget.show();
    }
}
