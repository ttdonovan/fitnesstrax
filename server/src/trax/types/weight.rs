//use chrono::prelude::*;
use dimensioned::si::Kilogram;
use emseries::{DateTimeTz, Recordable};

#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
pub struct Weight(Kilogram<f64>);

impl Weight {
    pub fn new(val: Kilogram<f64>) -> Weight {
        Weight(val)
    }
}

#[derive(Clone, Debug, PartialEq, Deserialize, Serialize)]
pub struct WeightRecord {
    pub date: DateTimeTz,
    pub weight: Weight,
}

impl Recordable for WeightRecord {
    fn timestamp(&self) -> DateTimeTz {
        self.date.clone()
    }

    fn tags(&self) -> Vec<String> {
        Vec::new()
    }
}
