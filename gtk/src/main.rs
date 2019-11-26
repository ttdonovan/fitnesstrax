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
pub(crate) mod context;
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
        window.set_title("Counter");
        window.set_default_size(350, 70);

        let main_panel = gtk::Box::new(gtk::Orientation::Vertical, 5);
        window.add(&main_panel);

        /*
        let counter_label = gtk::Label::new(Some("0"));
        let label_clone = counter_label.clone();
        ctx.write()
            .unwrap()
            .register_listener(Box::new(move |new_value| {
                label_clone.set_markup(&format!("{:?}", new_value));
            }));
            */

        let history = components::History::new(ctx.clone());

        main_panel.pack_start(history.render(), true, true, 5);

        window.show_all();
    });

    application.run(&[]);
}
