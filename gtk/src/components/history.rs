//use super::basics::day_c;
use std::sync::{Arc, RwLock};

use crate::context::{AppContext, Message};

pub struct History {
    ctx: Arc<RwLock<AppContext>>,
    widget: gtk::Box,
}

impl History {
    pub fn new(ctx: Arc<RwLock<AppContext>>) -> History {
        ctx.write().unwrap().register_listener(Box::new(|message| {
            println!("Message received: {:?}", message)
        }));

        History {
            ctx,
            widget: gtk::Box::new(gtk::Orientation::Vertical, 5),
        }
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
