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
struct AppContext {
    count: u32,
}

impl AppContext {
    fn new() -> AppContext {
        AppContext {
            count: Arc::new(RwLock::new(0)),
        }
    }

    fn increment(&mut self) {
        self.val = self.val + 1;
    }

    fn decrement(&mut self) {
        self.val = self.val - 1
    }
}

struct IncCtx {
    ctx: AppContext,
}

impl Fn<Args> for IncCtx
where
    Args: Display,
{
    fn call(&self, args: Args) {
        self.ctx.increment();
    }
}

/*
struct DecCtx {
    ctx: AppContext,
}

impl DecCtx {
    fn run(&mut self) {
        self.ctx.decrement();
    }
}
*/

fn main() {
    let application = gtk::Application::new(
        Some("com.github.luminescent-dreams.fitnesstrax"),
        Default::default(),
    )
    .expect("failed to initialize GTK application");

    application.connect_activate(|app| {
        let ctx = AppContext::new();
        let mut dec_ctx = DecCtx { ctx: ctx.clone() };
        let mut inc_ctx = IncCtx { ctx: ctx.clone() };

        let window = gtk::ApplicationWindow::new(app);
        window.set_title("Counter");
        window.set_default_size(350, 70);

        let main_panel = gtk::Box::new(gtk::Orientation::Vertical, 5);
        window.add(&main_panel);

        let counter_label = gtk::Label::new(Some("0"));
        let dec_button = gtk::Button::new_with_label("-1");
        dec_button.connect_clicked(dec_ctx);

        let inc_button = gtk::Button::new_with_label("+1");
        inc_button.connect_clicked(inc_ctx);

        main_panel.pack_start(&counter_label, true, true, 5);
        let button_box = gtk::Box::new(gtk::Orientation::Horizontal, 5);
        button_box.pack_start(&dec_button, true, true, 5);
        button_box.pack_start(&inc_button, true, true, 5);
        main_panel.pack_start(&button_box, true, true, 5);

        window.show_all();
    });

    application.run(&[]);
}
