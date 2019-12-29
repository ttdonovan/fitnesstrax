use dimensioned::si::Kilogram;
use emseries::{Recordable, UniqueId};
use fitnesstrax::weight::WeightRecord;

use crate::components::ValidatedTextEntry;
use crate::conversions::parse_mass;

pub fn weight_record_c(record: &WeightRecord) -> gtk::Label {
    gtk::Label::new(Some(&format!("{} kg", &record.weight.value_unsafe)))
}

pub fn weight_record_edit_c(
    id: UniqueId,
    record: WeightRecord,
    on_update: Box<dyn Fn(UniqueId, WeightRecord)>,
) -> ValidatedTextEntry<Kilogram<f64>> {
    ValidatedTextEntry::new(
        record.weight,
        Box::new(|w| format!("{}", w.value_unsafe)),
        Box::new(|s| parse_mass(s)),
        Box::new(move |val| on_update(id.clone(), WeightRecord::new(record.timestamp(), val))),
    )
}
