use chrono::Date;
use chrono_tz::Tz;
use emseries::Record;
use fitnesstrax::TraxRecord;
use gtk::prelude::*;
use std::sync::{Arc, RwLock};

use crate::components::{Component, Day, RangeSelector};
use crate::context::AppContext;
use crate::i18n::Messages;
use crate::preferences::Preferences;
use crate::range::group_by_date;
use crate::types::DateRange;

struct HistoryComponent {
    widget: gtk::Box,
    history_box: gtk::Box,
}

pub struct History {
    component: Option<HistoryComponent>,
    ctx: Arc<RwLock<AppContext>>,
}

impl History {
    pub fn new(ctx: Arc<RwLock<AppContext>>) -> History {
        History {
            component: None,
            ctx,
        }
    }

    pub fn render(
        &mut self,
        messages: Messages,
        prefs: Preferences,
        range: DateRange,
        records: Vec<Record<TraxRecord>>,
    ) -> &gtk::Box {
        match self.component {
            None => {
                let widget = gtk::Box::new(gtk::Orientation::Horizontal, 5);
                let history_box = gtk::Box::new(gtk::Orientation::Vertical, 5);

                let range_bar = {
                    let ctx = self.ctx.clone();
                    RangeSelector::new(
                        range.clone(),
                        Box::new(move |new_range| ctx.write().unwrap().set_range(new_range)),
                    )
                };
                let no_adjustment: Option<&gtk::Adjustment> = None;
                let scrolling_history = gtk::ScrolledWindow::new(no_adjustment, no_adjustment);
                scrolling_history.add(&history_box);

                widget.pack_start(&range_bar.widget, false, false, 25);
                widget.pack_start(&scrolling_history, true, true, 5);

                widget.show();
                history_box.show_all();
                scrolling_history.show();
                range_bar.show();

                self.component = Some(HistoryComponent {
                    widget,
                    history_box,
                });

                self.render(messages, prefs, range, records)
            }
            Some(HistoryComponent {
                ref widget,
                ref history_box,
                ..
            }) => {
                let grouped_history = group_by_date(range, records);
                history_box.foreach(|child| child.destroy());
                let mut dates = grouped_history.keys().collect::<Vec<&Date<Tz>>>();
                dates.sort_unstable();
                dates.reverse();
                dates.iter().for_each(|date| {
                    let ctx = self.ctx.clone();
                    let day = Day::new(
                        ctx,
                        *date.clone(),
                        grouped_history.get(date).unwrap().clone(),
                        messages.clone(),
                        prefs.clone(),
                    );
                    history_box.pack_start(&day.render(), true, true, 25);
                });
                &widget
            }
        }
    }
}
