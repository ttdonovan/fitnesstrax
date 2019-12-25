use emseries::{Recordable, UniqueId};
use fitnesstrax::steps::StepRecord;

use crate::components::ValidatedTextEntry;
use crate::errors::Error;

pub fn steps_c(record: &fitnesstrax::steps::StepRecord) -> gtk::Label {
    gtk::Label::new(Some(&format!("{} Steps", record.steps)))
}

pub fn steps_edit_c(
    id: UniqueId,
    value: u32,
    on_update: Box<dyn Fn(UniqueId, u32)>,
) -> ValidatedTextEntry<u32> {
    ValidatedTextEntry::new(
        value,
        Box::new(|s| s.parse::<u32>().map_err(|err| Error::ParseStepsError)),
        Box::new(move |res| match res {
            Some(val) => on_update(id.clone(), val),
            None => (),
        }),
    )
}
