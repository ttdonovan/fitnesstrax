//use super::basics::day_c;
use crate::gtk::BoxExt;
use std::sync::{Arc, RwLock};

use crate::components::day::day_c;
use crate::context::{AppContext, Message};
use crate::range::group_by_date;

pub struct History {
    ctx: Arc<RwLock<AppContext>>,
    widget: gtk::Box,
}

impl History {
    pub fn new(ctx: Arc<RwLock<AppContext>>) -> History {
        let widget = gtk::Box::new(gtk::Orientation::Vertical, 5);

        let history = group_by_date(
            ctx.read().unwrap().get_range(),
            ctx.read().unwrap().get_history().unwrap(),
        );

        let dates = history.keys();
        dates.for_each(|date| {
            widget.pack_start(&day_c(date, history.get(date).unwrap()), true, true, 5)
        });

        ctx.write().unwrap().register_listener(Box::new(|message| {
            println!("Message received: {:?}", message)
        }));

        History { ctx, widget }
    }

    /*
    fn range_update(&self, new_range: &DateRange) {
        println!("{:?}", new_range);
    }
    */

    pub fn render(&self) -> &gtk::Box {
        &self.widget
    }
}
