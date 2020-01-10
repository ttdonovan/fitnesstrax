use gtk::prelude::*;
use std::sync::{Arc, RwLock};

use crate::components::{entry_setting_c, pulldown_setting_c};
use crate::context::AppContext;

pub struct Preferences {
    pub widget: gtk::Box,
}

impl Preferences {
    pub fn new(ctx: Arc<RwLock<AppContext>>) -> Preferences {
        let ctx_ = ctx.read().unwrap();
        let widget = gtk::Box::new(gtk::Orientation::Vertical, 5);

        {
            let ctx = ctx.clone();
            widget.pack_start(
                &entry_setting_c(
                    "Database path",
                    ctx_.get_series_path(),
                    Box::new(move |s| ctx.write().unwrap().set_series_path(s)),
                ),
                false,
                false,
                5,
            );
        }

        {
            let ctx = ctx.clone();
            widget.pack_start(
                &pulldown_setting_c(
                    "Language",
                    vec![("en", "English"), ("eo", "Esperanto")],
                    ctx_.get_language(),
                    Box::new(move |s| ctx.write().unwrap().set_language(s)),
                ),
                false,
                false,
                5,
            );
        }

        {
            let ctx = ctx.clone();
            widget.pack_start(
                &pulldown_setting_c(
                    "Timezone",
                    tz_list(),
                    ctx_.get_timezone().name(),
                    Box::new(move |s| ctx.write().unwrap().set_timezone(s.parse().unwrap())),
                ),
                false,
                false,
                5,
            );
        }

        {
            let ctx = ctx.clone();
            widget.pack_start(
                &pulldown_setting_c(
                    "Units",
                    vec![("SI", "SI (kg, km, m/s)"), ("USA", "USA (lbs, mi, mph)")],
                    ctx_.get_units(),
                    Box::new(move |s| ctx.write().unwrap().set_units(s)),
                ),
                false,
                false,
                5,
            );
        }

        let w = Preferences { widget };

        w.show();

        w
    }

    pub fn show(&self) {
        self.widget.show_all();
    }
}

fn tz_list() -> Vec<(&'static str, &'static str)> {
    vec![
        ("America/Chicago", "United States: Chicago"),
        ("America/New_York", "United States: New York"),
    ]
}
