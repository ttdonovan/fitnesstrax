use emseries::{Recordable, UniqueId};
use fitnesstrax::weight::WeightRecord;
use gtk::prelude::*;

use crate::components::validated_text_entry_c;
use crate::errors::Error;
use crate::settings::Settings;

pub fn weight_record_c(record: &WeightRecord, settings: &Settings) -> gtk::Label {
    gtk::Label::new(Some(&settings.text.mass(&record.weight)))
}

pub fn weight_record_edit_c(
    id: UniqueId,
    record: WeightRecord,
    settings: &Settings,
    on_update: Box<dyn Fn(UniqueId, WeightRecord)>,
) -> gtk::Box {
    let b = gtk::Box::new(gtk::Orientation::Horizontal, 5);
    let u1 = settings.units.clone();
    let u2 = settings.units.clone();
    let entry = validated_text_entry_c(
        record.weight,
        Box::new(move |w| format!("{:.1}", u1.mass(&w))),
        Box::new(move |s| match u2.parse_mass(s) {
            Ok(Some(v)) => Ok(v),
            Ok(None) => Err(Error::ParseMassError),
            Err(_) => Err(Error::ParseMassError),
        }),
        Box::new(move |val| on_update(id.clone(), WeightRecord::new(record.timestamp(), val))),
    );

    let units_label = gtk::Label::new(Some(&settings.text.mass_label()));

    b.pack_start(&entry, false, false, 5);
    b.pack_start(&units_label, false, false, 5);
    b
}
