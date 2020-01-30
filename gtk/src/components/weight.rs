use emseries::{Recordable, UniqueId};
use fitnesstrax::weight::WeightRecord;

use crate::components::validated_text_entry_c;
use crate::conversions::{parse_mass, render_mass};
use crate::errors::Error;
use crate::i18n::UnitSystem;
use crate::settings::Settings;

pub fn weight_record_c(record: &WeightRecord, settings: &Settings) -> gtk::Label {
    gtk::Label::new(Some(&settings.text.mass(&record.weight)))
}

pub fn weight_record_edit_c(
    id: UniqueId,
    record: WeightRecord,
    unit: &UnitSystem,
    on_update: Box<dyn Fn(UniqueId, WeightRecord)>,
) -> gtk::Entry {
    let u1 = unit.clone();
    let u2 = unit.clone();
    validated_text_entry_c(
        record.weight,
        Box::new(move |w| render_mass(&w, &u1, false)),
        Box::new(move |s| match parse_mass(s, &u2) {
            Ok(Some(v)) => Ok(v),
            Ok(None) => Err(Error::ParseMassError),
            Err(_) => Err(Error::ParseMassError),
        }),
        Box::new(move |val| on_update(id.clone(), WeightRecord::new(record.timestamp(), val))),
    )
}
