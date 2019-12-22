use core::fmt::Display;
use gtk::{EditableSignals, EntryExt};
use std::sync::{Arc, RwLock};

#[derive(Clone)]
pub struct ValidatedTextEntry<A: Clone> {
    pub widget: gtk::Entry,
    value: Arc<RwLock<Result<A, String>>>,
}

impl<A: Clone> ValidatedTextEntry<A> {
    pub fn new(
        value: A,
        parse: Box<dyn Fn(&str) -> Result<A, String>>,
        on_update: Box<dyn Fn(Result<A, String>)>,
    ) -> ValidatedTextEntry<A>
    where
        A: 'static + Display + Clone,
    {
        let widget = gtk::Entry::new();
        widget.set_text(&format!("{}", value));

        let w = ValidatedTextEntry {
            widget,
            value: Arc::new(RwLock::new(Ok(value.clone()))),
        };

        let w_ = w.clone();
        w.widget.connect_changed(move |v| match v.get_text() {
            Some(ref s) => {
                *w_.value.write().unwrap() = parse(s.as_str());
                on_update(w_.value.read().unwrap().clone());
            }
            None => (),
        });

        w
    }
}
