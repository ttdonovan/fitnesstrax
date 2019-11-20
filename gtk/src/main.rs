extern crate chrono;
extern crate chrono_tz;
extern crate emseries;
extern crate gio;
extern crate gtk;

use chrono::TimeZone;
use chrono_tz::Tz;
use emseries::*;
use gio::prelude::*;
use gtk::prelude::*;
use gtk::BoxExt;
use std::env;
use std::path;
use std::sync::{Arc, RwLock};

use fitnesstrax;
use fitnesstrax_gtk;

#[derive(Debug)]
struct Configuration {
    series_path: path::PathBuf,
    timezone: chrono_tz::Tz,
}

impl Configuration {
    fn load_from_environment() -> Configuration {
        let series_path = env::var("SERIES_PATH").expect("SERIES_PATH to be specified");
        let timezone = env::var("TZ")
            .expect("TZ to be specified")
            .parse()
            .expect("a valid timezone");
        Configuration {
            series_path: path::PathBuf::from(series_path),
            timezone,
        }
    }
}

fn main() {
    let config = Configuration::load_from_environment();

    let trax = fitnesstrax::Trax::new(fitnesstrax::Params {
        series_path: config.series_path.clone(),
    })
    .unwrap();
    let app_rc = Arc::new(RwLock::new(trax));

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
                config.timezone.ymd(2019, 9, 1),
                config.timezone.ymd(2019, 9, 30),
            ),
            app_rc
                .read()
                .unwrap()
                .get_history(
                    emseries::DateTimeTz(config.timezone.ymd(2019, 9, 1).and_hms(0, 0, 0)),
                    emseries::DateTimeTz(config.timezone.ymd(2019, 9, 30).and_hms(0, 0, 0)),
                )
                .unwrap(),
        );

        let mut dates = fitnesstrax_gtk::dates_in_range(fitnesstrax_gtk::Range::new(
            config.timezone.ymd(2019, 9, 1),
            config.timezone.ymd(2019, 9, 30),
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
