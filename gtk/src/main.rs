extern crate chrono;
extern crate chrono_tz;
extern crate fitnesstrax;
extern crate gio;
extern crate glib;
extern crate gtk;
extern crate serde;

use gio::prelude::*;
use std::sync::{Arc, RwLock};

mod components;
mod config;
mod context;
mod conversions;
mod errors;
mod i18n;
mod range;
mod settings;
mod types;

fn main() {
    let application = gtk::Application::new(
        Some("com.github.luminescent-dreams.fitnesstrax"),
        Default::default(),
    )
    .expect("failed to initialize GTK application");

    application.connect_activate(move |app| {
        let (tx, rx) = glib::MainContext::channel(glib::PRIORITY_DEFAULT);

        let ctx = Arc::new(RwLock::new(context::AppContext::new(tx).unwrap()));
        let gui = Arc::new(RwLock::new(components::MainWindow::new(ctx.clone(), app)));

        let gui_clone = gui.clone();
        rx.attach(None, move |msg| {
            println!("Message received in GTK: {:?}", msg);
            gui_clone.write().unwrap().update_from(msg);
            glib::Continue(true)
        });

        {
            let ctx = ctx.read().unwrap();
            let mut g = gui.write().unwrap();
            g.render(
                ctx.get_settings(),
                ctx.get_range(),
                ctx.get_history().unwrap(),
            );
        }
    });

    application.run(&[]);
}
