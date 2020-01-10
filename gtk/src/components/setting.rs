use gtk::prelude::*;

pub fn setting_c(label: &str, options: Vec<(&str, &str)>, current: &str) -> gtk::Box {
    let widget = gtk::Box::new(gtk::Orientation::Horizontal, 5);
    widget.pack_start(&gtk::Label::new(Some(label)), true, true, 5);

    let combo = gtk::ComboBoxText::new();
    for (id, option) in options.iter() {
        combo.append(Some(id), option);
    }
    combo.set_active_id(Some(current));

    widget.pack_start(&combo, true, true, 5);

    widget
}
