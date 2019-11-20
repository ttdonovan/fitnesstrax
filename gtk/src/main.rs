extern crate chrono;
extern crate chrono_tz;
extern crate emseries;
extern crate gio;
extern crate gtk;
extern crate serde;

use chrono::TimeZone;
use gio::prelude::*;
use gtk::prelude::*;
use gtk::BoxExt;
use serde::{Deserialize, Serialize};
use std::env;
use std::error;
use std::fmt;
use std::fs::File;
use std::path;
use std::result;
use std::sync::{Arc, RwLock};

use fitnesstrax;
use fitnesstrax_gtk;

#[derive(Debug)]
pub enum Error {
    NoError,
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Error::NoError => write!(f, "no errors are currently supported"),
        }
    }
}

impl error::Error for Error {
    fn description(&self) -> &str {
        match self {
            Error::NoError => "no errors",
        }
    }

    fn cause(&self) -> Option<&(dyn error::Error + 'static)> {
        match self {
            Error::NoError => None,
        }
    }
}

type Result<A> = result::Result<A, Error>;

#[derive(Debug, Serialize, Deserialize)]
struct Configuration {
    series_path: path::PathBuf,
    timezone: chrono_tz::Tz,
    language: String,
}

impl Configuration {
    fn load_from_yaml() -> Configuration {
        let config_path = env::var("CONFIG").unwrap_or("config.yaml".to_string());
        let config_file = File::open(config_path.clone())
            .expect(&format!("cannot open configuration file: {}", &config_path));
        serde_yaml::from_reader(config_file).expect("invalid configuration file")
    }
}

struct AppContext {
    config: Configuration,
    trax: Arc<RwLock<fitnesstrax::Trax>>,
}

impl AppContext {
    fn new() -> Result<AppContext> {
        let config = Configuration::load_from_yaml();

        let trax = fitnesstrax::Trax::new(fitnesstrax::Params {
            series_path: config.series_path.clone(),
        })
        .unwrap();
        let trax_rc = Arc::new(RwLock::new(trax));
        Ok(AppContext {
            config,
            trax: trax_rc,
        })
    }
}

fn main() {
    let ctx = AppContext::new().unwrap();

    let application = gtk::Application::new(
        Some("com.github.luminescent-dreams.fitnesstrax"),
        Default::default(),
    )
    .expect("failed to initialize GTK application");

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

        let history = fitnesstrax_gtk::group_by_date(
            fitnesstrax_gtk::Range::new(
                ctx.config.timezone.ymd(2019, 9, 1),
                ctx.config.timezone.ymd(2019, 9, 30),
            ),
            ctx.trax
                .read()
                .unwrap()
                .get_history(
                    emseries::DateTimeTz(ctx.config.timezone.ymd(2019, 9, 1).and_hms(0, 0, 0)),
                    emseries::DateTimeTz(ctx.config.timezone.ymd(2019, 9, 30).and_hms(0, 0, 0)),
                )
                .unwrap(),
        );

        let mut dates = fitnesstrax_gtk::dates_in_range(fitnesstrax_gtk::Range::new(
            ctx.config.timezone.ymd(2019, 9, 1),
            ctx.config.timezone.ymd(2019, 9, 30),
        ));
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

    application.run(&[]);
}
