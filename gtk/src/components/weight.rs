use dimensioned::si::{Kilogram, KG};
use dimensioned::unit_systems::fps::LB;
use regex::Regex;

use crate::components::ValidatedTextEntry;
use emseries::Recordable;
use fitnesstrax::weight::WeightRecord;

pub fn weight_record_c(record: &WeightRecord) -> gtk::Label {
    gtk::Label::new(Some(&format!("{}", &record.weight.value_unsafe)))
}

const KG_PER_POUND: f64 = 0.4535924;

fn parse_mass(inp: &str) -> Result<Kilogram<f64>, String> {
    let re = Regex::new(r"(\d+\.?\d+)\s?(\w+)").unwrap();
    let captures = re.captures(inp);
    match captures {
        Some(caps) => match caps.len() {
            0 => Err(String::from("no data")),
            1 => Err(String::from("no data")),
            2 => Err(String::from("need both number and unit")),
            _ => {
                let val = caps[1].parse::<f64>().map_err(|err| format!("{}", err))?;
                match caps[2].to_lowercase().as_str() {
                    "kg" => Ok(val * KG),
                    "lb" => Ok(val * KG_PER_POUND * KG),
                    _ => Err(String::from("invalid units")),
                }
            }
        },
        None => Err(String::from("no data")),
    }
}

pub fn weight_record_edit_c(
    id: emseries::UniqueId,
    record: &WeightRecord,
    on_update: (Box<dyn Fn(Result<WeightRecord, String>)>),
) -> ValidatedTextEntry<Kilogram<f64>> {
    let record_ = record.clone();
    ValidatedTextEntry::new(
        record.weight,
        Box::new(|s| parse_mass(s)),
        Box::new(move |res| match res {
            Ok(val) => on_update(Ok(WeightRecord::new(record_.timestamp(), val))),
            Err(err) => on_update(Err(err)),
        }),
    )
}

/*
#[derive(Clone)]
pub struct WeightRecordEditField {
    pub widget: gtk::Entry,
    pub id: emseries::UniqueId,
    record: fitnesstrax::weight::WeightRecord,
}

impl WeightRecordEditField {
    pub fn new(
        id: emseries::UniqueId,
        record: &fitnesstrax::weight::WeightRecord,
    ) -> WeightRecordEditField {
        let record = record.clone();
        let edit = Arc::new(RwLock::new(record.clone()));

        let entry = gtk::Entry::new();
        entry.set_text(&format!("{}", edit.read().unwrap().weight.value_unsafe));

        {
            let entry_ = entry.clone();
            let edit = edit.clone();
            entry.connect_changed(move |v| match v.get_text() {
                Some(ref s) => match s.as_str().parse::<f64>() {
                    Ok(val_) => edit.write().unwrap().weight = val_ * KG,
                    Err(_) => {
                        entry_.set_text(&format!("{}", edit.read().unwrap().weight.value_unsafe))
                    }
                },
                None => (),
            });
        }

        WeightRecordEditField {
            widget: entry,
            id,
            record,
            edit,
        }
    }

    pub fn is_updated(&self) -> bool {
        self.record == *self.edit.read().unwrap()
    }

    pub fn value(&self) -> fitnesstrax::weight::WeightRecord {
        self.edit.read().unwrap().clone()
    }

    pub fn show(&self) {}
}
*/
