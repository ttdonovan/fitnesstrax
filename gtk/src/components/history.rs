use gtk::prelude::*;

use super::basics::day_c;

pub struct History<'ctx> {
    ctx: &'ctx AppContext,
    widget: gtk::Box,
}

impl<'ctx> History<'ctx> {
    pub fn new(ctx: &'ctx AppContext) -> History<'ctx> {
        ctx.register_range_listener()
    }

    fn range_update(&self, new_range: &DateRange) {
        println!("{:?}", new_range);
    }

    pub fn render(&self) -> &gtk::Box {
        &self.widget
    }
}
