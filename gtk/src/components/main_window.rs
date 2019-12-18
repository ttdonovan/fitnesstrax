use crate::context::AppContext;
use chrono::{DateTime, TimeZone};
use chrono_tz;
use gtk::prelude::*;
use std::sync::{Arc, RwLock};
use std::thread;

use crate::components::*;
use crate::types::DateRange;

/*
pub struct Handlers {
    range_change: Option<Box<dyn Fn(DateRange)>>,
}

impl Default for Handlers {
    fn default() -> Handlers {
        Handlers { range_change: None }
    }
}
*/

pub struct MainWindow {
    pub widget: gtk::ApplicationWindow,
    menubar: MenuBar,
    history: History,
    /*
    pub start_selector: DateSelector,
    end_selector: DateSelector,
    */
}

impl MainWindow {
    pub fn new(ctx: Arc<RwLock<AppContext>>, app: &gtk::Application) -> MainWindow {
        let widget = gtk::ApplicationWindow::new(app);
        let menubar = MenuBar::new();
        let history = History::new(ctx.clone());

        //main_panel.pack_start(menubar.render(), false, false, 5);

        //main_panel.show();
        //history.show();
        //menubar.show();
        //widget.show_all();

        let range = ctx.read().unwrap().get_range();

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

    //pub fn update_handlers(&mut self, handlers: Handlers) {}

    pub fn update_from(&mut self, ctx: &AppContext) {
        let range = ctx.get_range();
        let records = ctx.get_history().unwrap();
        self.history.update_from(range, records);
        //self.start_selector.update_from(range.start.clone());
        //self.end_selector.update_from(range.end.clone());
    }

    pub fn show(&self) {
        self.menubar.show();
        self.history.show();
        self.widget.show();
    }
}
