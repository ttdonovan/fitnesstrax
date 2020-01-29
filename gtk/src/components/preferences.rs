use gtk::prelude::*;
use std::convert::TryFrom;
use std::sync::{Arc, RwLock};

use crate::components::{entry_setting_c, pulldown_setting_c};
use crate::context::AppContext;
use crate::preferences;

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
        let mut prefs = ctx.get_preferences();
        prefs.language = String::from(language);
        ctx.set_preferences(prefs);
    }

    pub fn set_timezone(&self, timezone_str: &str) {
        let mut ctx = self.ctx.write().unwrap();
        let mut prefs = ctx.get_preferences();
        prefs.timezone = timezone_str.parse().unwrap();
        ctx.set_preferences(prefs);
    }

    pub fn set_units(&self, units: &str) {
        let mut ctx = self.ctx.write().unwrap();
        let mut prefs = ctx.get_preferences();
        prefs.units = preferences::UnitSystem::try_from(units).unwrap();
        ctx.set_preferences(prefs);
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
                let preferences::Preferences {
                    language,
                    timezone,
                    units,
                } = self.ctx.read().unwrap().get_preferences();

                let messages = self.ctx.read().unwrap().get_messages();

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
                            messages.tr("language").as_ref().map(|c| &**c).unwrap(),
                            vec![("en", "English"), ("eo", "Esperanto")],
                            &language,
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
                            messages.tr("timezone").as_ref().map(|c| &**c).unwrap(),
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
                            messages.tr("units").as_ref().map(|c| &**c).unwrap(),
                            vec![("SI", "SI (kg, km, m/s)"), ("USA", "USA (lbs, mi, mph)")],
                            &String::from(units),
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
