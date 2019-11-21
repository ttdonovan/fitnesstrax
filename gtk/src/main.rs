extern crate chrono;
extern crate chrono_tz;
extern crate emseries;
extern crate gio;
extern crate gtk;
extern crate serde;

use gio::prelude::*;
use gtk::prelude::*;
use gtk::BoxExt;
use std::sync::{Arc, RwLock};

#[derive(Clone)]
struct AppContext<F: Fn(u32) + 'static> {
    count: u32,
    change_listeners: Vec<F>,
}

impl<F: Fn(u32) + 'static> AppContext<F> {
    fn new() -> AppContext<F> {
        AppContext {
            count: 0,
            change_listeners: Vec::new(),
        }
    }

    fn increment(&mut self) {
        self.count = self.count + 1;
        println!("new value: {}", self.count);
        self.change_listeners
            .iter()
            .for_each(|listener| listener(self.count));
    }

    fn decrement(&mut self) {
        self.count = self.count - 1;
        println!("new value: {}", self.count);
        self.change_listeners
            .iter()
            .for_each(|listener| listener(self.count));
    }

    fn register_listener(&mut self, listener: F) {
        self.change_listeners.push(listener);
    }
}

fn main() {
    let ctx = Arc::new(RwLock::new(AppContext::new()));

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

        let counter_label = gtk::Label::new(Some("0"));
        let label_clone = counter_label.clone();
        ctx.write().unwrap().register_listener(move |new_value| {
            label_clone.set_markup(&format!("{}", new_value));
        });

        let dec_button = gtk::Button::new_with_label("-1");
        let dec_ctx = ctx.clone();
        dec_button.connect_clicked(move |_f| dec_ctx.write().unwrap().decrement());

        let inc_button = gtk::Button::new_with_label("+1");
        let inc_ctx = ctx.clone();
        inc_button.connect_clicked(move |_f| inc_ctx.write().unwrap().increment());

        main_panel.pack_start(&counter_label, true, true, 5);
        let button_box = gtk::Box::new(gtk::Orientation::Horizontal, 5);
        button_box.pack_start(&dec_button, true, true, 5);
        button_box.pack_start(&inc_button, true, true, 5);
        main_panel.pack_start(&button_box, true, true, 5);

        window.show_all();
    });

    application.run(&[]);
}
