use gtk::{EditableSignals, EntryExt, StyleContextExt, WidgetExt};
use std::sync::{Arc, RwLock};

use crate::errors::Error;

#[derive(Clone)]
pub struct ValidatedTextEntry<A: Clone> {
    pub widget: gtk::Entry,
    value: Arc<RwLock<Result<A, Error>>>,
}

impl<A: Clone> ValidatedTextEntry<A> {
    pub fn new(
        value: A,
        render: Box<dyn Fn(&A) -> String>,
        parse: Box<dyn Fn(&str) -> Result<A, Error>>,
        on_update: Box<dyn Fn(A)>,
    ) -> ValidatedTextEntry<A>
    where
        A: 'static + Clone,
    {
        let widget = gtk::Entry::new();
        widget.set_text(&render(&value));

        let w = ValidatedTextEntry {
            widget,
            value: Arc::new(RwLock::new(Ok(value.clone()))),
        };

        let w_ = w.clone();
        w.widget.connect_changed(move |v| match v.get_text() {
            Some(ref s) => match parse(s.as_str()) {
                Ok(val) => {
                    let context = w_.widget.get_style_context();
                    context.remove_class(&gtk::STYLE_CLASS_WARNING);
                    *w_.value.write().unwrap() = Ok(val.clone());
                    on_update(val);
                }
                Err(err) => {
                    let context = w_.widget.get_style_context();
                    context.add_class(&gtk::STYLE_CLASS_WARNING);
                    *w_.value.write().unwrap() = Err(err);
                }
            },
            None => (),
        });

        w
    }
}
