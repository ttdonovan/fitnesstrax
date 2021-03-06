use emseries::{Recordable, UniqueId};
use fitnesstrax::steps::StepRecord;

use crate::components::validated_text_entry_c;
use crate::errors::Error;

pub fn steps_c(record: &fitnesstrax::steps::StepRecord) -> gtk::Label {
    gtk::Label::new(Some(&format!("{} Steps", record.steps)))
}

pub fn steps_edit_c(
    id: UniqueId,
    record: StepRecord,
    on_update: Box<dyn Fn(UniqueId, StepRecord)>,
) -> gtk::Entry {
    validated_text_entry_c(
        record.steps,
        Box::new(|s| format!("{}", s)),
        Box::new(|s| s.parse::<u32>().map_err(|_err| Error::ParseStepsError)),
        Box::new(move |val| on_update(id.clone(), StepRecord::new(record.timestamp(), val))),
    )
}
