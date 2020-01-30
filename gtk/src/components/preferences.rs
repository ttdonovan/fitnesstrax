use gtk::prelude::*;
use std::convert::TryFrom;
use std::sync::{Arc, RwLock};

use crate::components::{entry_setting_c, pulldown_setting_c};
use crate::context::AppContext;
use crate::settings;

#[derive(Clone)]
pub struct Preferences {
    component: Option<gtk::Box>,
    ctx: Arc<RwLock<AppContext>>,
}

impl Preferences {
    pub fn new(ctx: Arc<RwLock<AppContext>>) -> Preferences {
        Preferences {
            component: None,
            ctx: ctx.clone(),
        }
    }

    pub fn set_language(&self, language: &str) {
        let mut ctx = self.ctx.write().unwrap();
        ctx.set_language(language);
    }

    pub fn set_timezone(&self, timezone_str: &str) {
        let mut ctx = self.ctx.write().unwrap();
        ctx.set_timezone(timezone_str.parse().unwrap());
    }

    pub fn set_units(&self, units: &str) {
        let mut ctx = self.ctx.write().unwrap();
        ctx.set_units(units);
    }

    pub fn render(&mut self) -> &gtk::Box {
        /* Doing all of the component setup in the initial construction because there is currently
         * no way for the values of a component to change outside of changes within this object.
         * However, this changes when I handle translation, because changing the translation
         * setting should trigger a total re-render. */

        match self.component {
            None => {
                let widget = gtk::Box::new(gtk::Orientation::Vertical, 5);

                let series_path = String::from(self.ctx.read().unwrap().get_series_path());
                let settings::Settings {
                    timezone,
                    units,
                    text,
                } = self.ctx.read().unwrap().get_settings();

                {
                    let ctx = self.ctx.clone();
                    widget.pack_start(
                        &entry_setting_c(
                            "Database path",
                            &series_path,
                            Box::new(move |s| ctx.write().unwrap().set_series_path(s)),
                        ),
                        false,
                        false,
                        5,
                    );
                }

                {
                    let w = self.clone();
                    widget.pack_start(
                        &pulldown_setting_c(
                            text.language().as_str(),
                            vec![("en", "English"), ("eo", "Esperanto")],
                            text.language_id(),
                            Box::new(move |s| w.set_language(s)),
                        ),
                        false,
                        false,
                        5,
                    );
                }

                {
                    let w = self.clone();
                    widget.pack_start(
                        &pulldown_setting_c(
                            &text.timezone(),
                            tz_list(),
                            timezone.name(),
                            Box::new(move |s| w.set_timezone(s)),
                        ),
                        false,
                        false,
                        5,
                    );
                }

                {
                    let w = self.clone();
                    widget.pack_start(
                        &pulldown_setting_c(
                            &text.units(),
                            vec![("SI", "SI (kg, km, m/s)"), ("USA", "USA (lbs, mi, mph)")],
                            &String::from(&units),
                            Box::new(move |s| w.set_units(s)),
                        ),
                        false,
                        false,
                        5,
                    );
                }

                widget.show_all();
                self.component = Some(widget);

                self.render()
            }
            Some(ref widget) => &widget,
        }
    }
}

fn tz_list() -> Vec<(&'static str, &'static str)> {
    vec![
        ("America/Chicago", "United States: Chicago"),
        ("America/New_York", "United States: New York"),
    ]
}
