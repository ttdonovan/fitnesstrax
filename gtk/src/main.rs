extern crate chrono;
extern crate chrono_tz;
extern crate emseries;
extern crate gio;
extern crate gtk;
extern crate serde;

use chrono::{TimeZone, Utc};
use gio::prelude::*;
use gtk::prelude::*;
use gtk::BoxExt;
use serde::{Deserialize, Serialize};
use std::env;
use std::error;
use std::fmt;
use std::fs::File;
use std::io;
use std::path;
use std::result;
use std::sync::{Arc, RwLock};

use fitnesstrax;
use fitnesstrax_gtk;

#[derive(Debug)]
pub enum Error {
    TraxError(fitnesstrax::Error),
    IOError(io::Error),
}

impl From<fitnesstrax::Error> for Error {
    fn from(error: fitnesstrax::Error) -> Self {
        Error::TraxError(error)
    }
}

impl From<io::Error> for Error {
    fn from(error: io::Error) -> Self {
        Error::IOError(error)
    }
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Error::TraxError(err) => write!(f, "Trax encountered an error: {}", err),
            Error::IOError(err) => write!(f, "IO Error: {}", err),
        }
    }
}

impl error::Error for Error {
    fn description(&self) -> &str {
        match self {
            Error::TraxError(err) => err.description(),
            Error::IOError(err) => err.description(),
        }
    }

    fn cause(&self) -> Option<&(dyn error::Error + 'static)> {
        match self {
            Error::TraxError(ref err) => Some(err),
            Error::IOError(ref err) => Some(err),
        }
    }
}

type Result<A> = result::Result<A, Error>;

#[derive(Clone)]
struct AppContext {
    count: Arc<RwLock<u32>>,
}

impl AppContext {
    fn new() -> AppContext {
        AppContext {
            count: Arc::new(RwLock::new(0)),
        }
    }

    fn increment(&mut self) {
        let mut val = self.count.write().unwrap();
        *val = *val + 1;
    }

    fn decrement(&mut self) {
        let mut val = self.count.write().unwrap();
        *val = *val - 1;
    }
}

struct IncCtx {
    ctx: AppContext,
}

impl Fn for IncCtx {
    fn call(&self, args: Args) {
        self.ctx.increment();
    }
}

struct DecCtx {
    ctx: AppContext,
}

impl DecCtx {
    fn run(&mut self) {
        self.ctx.decrement();
    }
}

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

    /*
    application.connect_activate(move |app| {
        let window = gtk::ApplicationWindow::new(app);
        window.set_title("Fitnesstrax");
        window.set_default_size(350, 70);

        let main_box = gtk::Box::new(gtk::Orientation::Horizontal, 5);

        let left_panel = gtk::Box::new(gtk::Orientation::Vertical, 5);
        left_panel.add(&gtk::Label::new(Some("date select panel")));

        let no_adjustment: Option<&gtk::Adjustment> = None;
        let scrolling_history = gtk::ScrolledWindow::new(no_adjustment, no_adjustment);
        let history_panel = gtk::Box::new(gtk::Orientation::Vertical, 5);
        scrolling_history.add(&history_panel);

        main_box.add(&left_panel);
        main_box.pack_end(&scrolling_history, true, true, 5);

        let range = (*ctx.range.read().unwrap()).clone();
        let history = fitnesstrax_gtk::group_by_date(
            range.clone(),
            ctx.trax
                .read()
                .unwrap()
                .get_history(
                    emseries::DateTimeTz(range.start.and_hms(0, 0, 0)),
                    emseries::DateTimeTz(range.end.and_hms(0, 0, 0)),
                )
                .unwrap(),
        );

        let mut dates = fitnesstrax_gtk::dates_in_range(range);
        dates.sort();

        for date in dates.into_iter() {
            history_panel.add(&fitnesstrax_gtk::day_c(
                &date,
                history.get(&date).unwrap_or(&vec![]),
            ));
        }

        window.add(&main_box);

        window.show_all();
    });
    */

    application.run(&[]);
}
