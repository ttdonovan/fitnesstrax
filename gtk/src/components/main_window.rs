use crate::context::AppContext;
use chrono::{DateTime, TimeZone};
use chrono_tz;
use gtk::prelude::*;
use std::sync::{Arc, RwLock};
use std::thread;

use crate::components::DateSelector;
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
    pub start_selector: DateSelector,
    end_selector: DateSelector,
}

impl MainWindow {
    pub fn new(ctx: Arc<RwLock<AppContext>>) -> MainWindow {
        //let menubar = components::MenuBar::new(ctx.clone());
        //let history = History::new(ctx, HistoryHandlers { range_change });

        //main_panel.pack_start(menubar.render(), false, false, 5);
        //main_panel.pack_start(&history.widget, true, true, 5);

        //main_panel.show();
        //history.show();
        //menubar.show();
        //widget.show_all();

        let range = ctx.read().unwrap().get_range();

        let start_selector = {
            let ctx_ = ctx.clone();
            let end_date_ = range.end.clone();
            DateSelector::new(
                range.start.clone(),
                Some(Box::new(move |new_date| {
                    ctx_.write().unwrap().set_range(DateRange {
                        start: new_date,
                        end: end_date_,
                    })
                })),
            )
        };
        let end_selector = DateSelector::new(range.end.clone(), None);

        MainWindow {
            start_selector,
            end_selector,
        }
    }

    //pub fn update_handlers(&mut self, handlers: Handlers) {}

    pub fn update_from(&mut self, ctx: &AppContext) {
        let range = ctx.get_range();
        self.start_selector.update_from(range.start.clone());
        self.end_selector.update_from(range.end.clone());
    }

    /*
    pub fn show(&self) {
        //self.widget.show();
        //self.history.show();
        //self.widget.show_all();
    }*/

    pub fn render(&self, app: &gtk::Application) {
        let widget = gtk::ApplicationWindow::new(app);
        widget.set_title("Fitnesstrax");
        widget.set_default_size(350, 70);

        let main_panel = gtk::Box::new(gtk::Orientation::Vertical, 5);
        main_panel.pack_start(&self.start_selector.render(), true, true, 5);
        main_panel.pack_start(&self.end_selector.render(), true, true, 5);
        widget.add(&main_panel);

        //let start_clone = self.start_selector.clone();
        /*
        thread::spawn(move || {
            thread::sleep(std::time::Duration::from_secs(1));
            println!("hey, an update happened");
            gtk::idle_add(move || {
                start_clone.update_from(
                    chrono::Utc
                        .ymd(2010, 1, 1)
                        .with_timezone(&chrono_tz::America::New_York),
                );
                Continue(true)
            });
        });
        */

        main_panel.show();

        widget.show();
    }
}
