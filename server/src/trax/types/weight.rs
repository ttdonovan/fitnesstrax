//use chrono::prelude::*;
use dimensioned::si::Kilogram;
use emseries::{DateTimeTz, Recordable};

#[derive(Clone, Debug, PartialEq, Deserialize, Serialize)]
pub struct WeightRecord {
    date: DateTimeTz,
    weight: Kilogram<f64>,
}

impl WeightRecord {
    pub fn new(date: DateTimeTz, weight: Kilogram<f64>) -> WeightRecord {
        WeightRecord { date, weight }
    }
}

impl Recordable for WeightRecord {
    fn timestamp(&self) -> DateTimeTz {
        self.date.clone()
    }

    fn tags(&self) -> Vec<String> {
        Vec::new()
    }
}
