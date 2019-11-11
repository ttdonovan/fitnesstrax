use chrono;

pub fn date_c(date: &chrono::Date<chrono_tz::Tz>) -> gtk::Label {
    gtk::Label::new(Some(&format!("{}", date.format("%B %e, %Y"))))
}

pub fn time_c(time: &chrono::NaiveTime) -> gtk::Label {
    gtk::Label::new(Some(&format!("{}", time.format("%H:%M:%S"))))
}
