use chrono::{Date, Datelike, TimeZone, Utc};
use chrono_tz::Etc::UTC;
use chrono_tz::Tz;
use gtk::prelude::*;

pub struct DateSelector {
    widget: gtk::Box,
    button: gtk::Button,
    calendar: gtk::Calendar,

    date: Date<Tz>,
}

impl DateSelector {
    pub fn new(date: Date<Tz>, on_change: Box<dyn Fn(Date<Tz>)>) -> DateSelector {
        let widget = gtk::Box::new(gtk::Orientation::Vertical, 5);

        let button = gtk::Button::new_with_label(&format!("{}", date.format("%B %e, %Y")));
        let calendar = gtk::Calendar::new();
        calendar.select_month(date.month0(), date.year() as u32);
        calendar.select_day(date.day());
        let button_clone = button.clone();
        calendar.connect_day_selected(move |cal| {
            let (year, month0, day) = cal.get_date();
            let date = Utc.ymd(year as i32, month0 + 1, day).with_timezone(&UTC);
            on_change(date);
            button_clone.set_label(&format!("{}", date.format("%B %e, %Y")));
        });
        let calendar_clone = calendar.clone();
        button.connect_clicked(move |_| calendar_clone.show());

        widget.pack_start(&button, true, true, 5);
        widget.pack_start(&calendar, true, true, 5);

        DateSelector {
            widget,
            button,
            calendar,

            date,
        }
    }

    pub fn show(&self) {
        self.widget.show();
        self.button.show();
    }

    pub fn render(&self) -> &gtk::Box {
        &self.widget
    }
}
