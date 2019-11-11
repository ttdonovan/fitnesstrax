use gtk::prelude::*;

use fitnesstrax;

pub fn weight_record_c(record: &fitnesstrax::weight::WeightRecord) -> gtk::Label {
    gtk::Label::new(Some(&format!("{}", &record.weight.value_unsafe)))
}
