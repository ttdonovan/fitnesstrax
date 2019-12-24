use core::fmt::Display;
use gtk::{EditableSignals, EntryExt};
use std::sync::{Arc, RwLock};

use crate::errors::Error;

#[derive(Clone)]
pub struct ValidatedTextEntry<A: Clone> {
    pub widget: gtk::Entry,
    value: Arc<RwLock<Option<A>>>,
}

impl<A: Clone> ValidatedTextEntry<A> {
    pub fn new(
        value: A,
        parse: Box<dyn Fn(&str) -> Result<A, Error>>,
        on_update: Box<dyn Fn(Option<A>)>,
    ) -> ValidatedTextEntry<A>
    where
        A: 'static + Display + Clone,
    {
        let widget = gtk::Entry::new();
        widget.set_text(&format!("{}", value));

        let w = ValidatedTextEntry {
            widget,
            value: Arc::new(RwLock::new(Some(value.clone()))),
        };

        let w_ = w.clone();
        w.widget.connect_changed(move |v| match v.get_text() {
            Some(ref s) => match parse(s.as_str()) {
                Ok(val) => {
                    *w_.value.write().unwrap() = Some(val);
                    on_update(w_.value.read().unwrap().clone());
                }
                Err(_err) => {
                    *w_.value.write().unwrap() = None;
                }
            },
            None => (),
        });

        w
    }
}
