use chrono;

pub fn date_c(date: &chrono::Date<chrono_tz::Tz>) -> gtk::Label {
    gtk::Label::new(Some(&format!("{}", date.format("%B %e, %Y"))))
}

pub fn time_c(time: &chrono::NaiveTime) -> gtk::Label {
    gtk::Label::new(Some(&format!("{}", time.format("%H:%M:%S"))))
}

pub fn distance_c(distance: &dimensioned::si::Meter<f64>) -> gtk::Label {
    gtk::Label::new(Some(&format!("{} m", distance.value_unsafe)))
}

pub fn duration_c(duration: &dimensioned::si::Second<f64>) -> gtk::Label {
    gtk::Label::new(Some(&format!("{} s", duration.value_unsafe)))
}
