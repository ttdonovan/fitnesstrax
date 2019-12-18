extern crate chrono;
extern crate chrono_tz;
extern crate fitnesstrax;
extern crate gio;
extern crate glib;
extern crate gtk;
extern crate serde;

use gio::prelude::*;
use gtk::prelude::*;
use gtk::BoxExt;
use std::sync::{Arc, RwLock};

mod components;
mod config;
mod context;
mod errors;
mod range;
mod types;

fn main() {
    let application = gtk::Application::new(
        Some("com.github.luminescent-dreams.fitnesstrax"),
        Default::default(),
    )
    .expect("failed to initialize GTK application");

    application.connect_activate(move |app| {
        let (tx, rx) = glib::MainContext::channel(glib::PRIORITY_DEFAULT);

        let mut ctx = Arc::new(RwLock::new(context::AppContext::new(tx).unwrap()));
        let mut gui = Arc::new(RwLock::new(components::MainWindow::new(ctx.clone(), app)));

        let ctx_clone = ctx.clone();
        let gui_clone = gui.clone();
        rx.attach(None, move |msg| {
            println!("Message received in GTK: {:?}", msg);
            gui_clone
                .write()
                .unwrap()
                .update_from(&*ctx_clone.read().unwrap());
            glib::Continue(true)
        });

        /*
        {
            let ctx_clone = ctx.clone();
            let gui_clone = gui.clone();
            gui.write()
                .unwrap()
                .start_selector
                .connect_change(Box::new(move |new_date| {
                    let mut ctx_ = ctx_clone.write().unwrap();
                    let range = ctx_.get_range();
                    ctx_.set_range(types::DateRange {
                        start: new_date,
                        end: range.end.clone(),
                    });

                    gui_clone.write().unwrap().update_from(&ctx_);
                }));
        }
                */

        let g = gui.read().unwrap();
        g.show()
    });

    application.run(&[]);
}
