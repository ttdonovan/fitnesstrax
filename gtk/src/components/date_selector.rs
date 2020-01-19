use chrono::{Date, Datelike, TimeZone, Utc};
use chrono_tz::Etc::UTC;
use chrono_tz::Tz;
use gtk::prelude::*;
use std::sync::Arc;

pub fn date_selector_c(date: Date<Tz>, on_change: Box<dyn Fn(Date<Tz>)>) -> gtk::Box {
    let component = gtk::Box::new(gtk::Orientation::Vertical, 5);

    let button = gtk::Button::new_with_label(&format!("{}", date.format("%B %e, %Y")));
    let calendar = gtk::Calendar::new();

    let on_change = Arc::new(on_change);

    calendar.select_month(date.month0(), date.year() as u32);
    calendar.select_day(date.day());

    {
        let cal = calendar.clone();
        button.connect_clicked(move |_| {
            if !cal.get_visible() {
                cal.show()
            } else {
                cal.hide()
            }
        });
    }

    {
        let on_change = on_change.clone();
        let button = button.clone();

        calendar.connect_day_selected(move |cal| {
            let (year, month0, day) = cal.get_date();
            let date = Utc.ymd(year as i32, month0 + 1, day).with_timezone(&UTC);
            button.set_label(&format!("{}", date.format("%B %e, %Y")));
            on_change(date);
        });
    }

    component.pack_start(&button, false, false, 5);
    component.pack_start(&calendar, false, false, 5);
    calendar.hide();

    component.show();
    button.show();

    component
}
