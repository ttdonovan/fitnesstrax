use gtk::EntryExt;

use fitnesstrax;

pub fn weight_record_c(record: &fitnesstrax::weight::WeightRecord) -> gtk::Label {
    gtk::Label::new(Some(&format!("{}", &record.weight.value_unsafe)))
}

pub fn weight_record_edit_c(record: &fitnesstrax::weight::WeightRecord) -> gtk::Entry {
    let entry = gtk::Entry::new();
    entry.set_text(&format!("{}", &record.weight.value_unsafe));
    entry
}
