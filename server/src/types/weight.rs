
use chrono::prelude::*;
use dimensioned::si::{KG, Kilogram};
use emseries::Recordable;
use serde::de::{Deserialize, Deserializer};
use serde::ser::{Serialize, Serializer};

use types::common::F64Visitor;

#[derive(Clone, Debug, PartialEq)]
pub struct Weight(Kilogram<f64>);

impl Weight {
    pub fn new(val: Kilogram<f64>) -> Weight {
        Weight(val)
    }
}

impl<'de> Deserialize<'de> for Weight {
    fn deserialize<D>(deserializer: D) -> Result<Weight, D::Error>
    where
        D: Deserializer<'de>,
    {
        let val = deserializer.deserialize_f64(F64Visitor)?;
        Ok(Weight(val * KG))
    }
}

impl Serialize for Weight {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        serializer.serialize_f64(self.0.value_unsafe)
    }
}



#[derive(Clone, Debug, PartialEq, Deserialize, Serialize)]
pub struct WeightRecord {
    pub date: DateTime<Utc>,
    pub weight: Weight,
}

impl Recordable for WeightRecord {
    fn timestamp(&self) -> DateTime<Utc> {
        self.date
    }

    fn tags(&self) -> Vec<String> {
        Vec::new()
    }

    fn values(&self) -> Vec<String> {
        Vec::new()
    }
}
