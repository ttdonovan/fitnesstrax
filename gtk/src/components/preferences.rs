use gtk::prelude::*;
use std::sync::{Arc, RwLock};

use crate::components::setting_c;
use crate::context::AppContext;

pub struct Preferences {
    pub widget: gtk::Box,
}

impl Preferences {
    pub fn new(ctx: Arc<RwLock<AppContext>>) -> Preferences {
        let config = ctx.read().unwrap().get_configuration();
        let widget = gtk::Box::new(gtk::Orientation::Vertical, 5);

        widget.pack_start(
            &setting_c(
                "Language",
                vec![("en", "English"), ("eo", "Esperanto")],
                config.language.as_str(),
            ),
            false,
            false,
            50,
        );

        widget.pack_start(
            &setting_c("Timezone", tz_list(), config.timezone.name()),
            false,
            false,
            50,
        );

        widget.pack_start(
            &setting_c(
                "Units",
                vec![("SI", "SI (kg, km, m/s)"), ("USA", "USA (lbs, mi, mph)")],
                config.units.as_str(),
            ),
            false,
            false,
            50,
        );

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
