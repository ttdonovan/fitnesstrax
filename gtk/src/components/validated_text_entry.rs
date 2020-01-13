use gtk::{EditableSignals, EntryExt, StyleContextExt, WidgetExt};

use crate::errors::Error;

pub fn validated_text_entry_c<A: 'static + Clone>(
    value: A,
    render: Box<dyn Fn(&A) -> String>,
    parse: Box<dyn Fn(&str) -> Result<A, Error>>,
    on_update: Box<dyn Fn(A)>,
) -> gtk::Entry {
    let widget = gtk::Entry::new();
    widget.set_text(&render(&value));

    let w = widget.clone();
    widget.connect_changed(move |v| match v.get_text() {
        Some(ref s) => match parse(s.as_str()) {
            Ok(val) => {
                let context = w.get_style_context();
                context.remove_class(&gtk::STYLE_CLASS_WARNING);
                on_update(val);
            }
            Err(err) => {
                let context = w.get_style_context();
                context.add_class(&gtk::STYLE_CLASS_WARNING);
            }
        },
        None => (),
    });

    widget
}
