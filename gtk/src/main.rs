extern crate chrono;
extern crate chrono_tz;
extern crate fitnesstrax;
extern crate gio;
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
    let ctx = Arc::new(RwLock::new(context::AppContext::new().unwrap()));

    let application = gtk::Application::new(
        Some("com.github.luminescent-dreams.fitnesstrax"),
        Default::default(),
    )
    .expect("failed to initialize GTK application");

    application.connect_activate(move |app| {
        let window = gtk::ApplicationWindow::new(app);
        window.set_title("Fitnesstrax");
        window.set_default_size(350, 70);

        let main_panel = gtk::Box::new(gtk::Orientation::Vertical, 5);
        window.add(&main_panel);

        let menubar = components::MenuBar::new(ctx.clone());
        let history = components::History::new(ctx.clone());

        main_panel.pack_start(menubar.render(), false, false, 5);
        main_panel.pack_start(history.render(), true, true, 5);

        window.show_all();
    });

    application.run(&[]);
}
