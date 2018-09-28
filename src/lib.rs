extern crate chrono;
extern crate dimensioned;
extern crate emseries;
extern crate serde;
#[macro_use] extern crate serde_derive;

use chrono::prelude::*;
use dimensioned::si::{ KG, Kilogram };
use emseries::{ Recordable };
use serde::de;
use serde::de::{ Deserialize, Deserializer, Visitor };
use serde::ser::{ Serialize, Serializer };
use std::fmt;


struct F64Visitor;

impl <'de> Visitor<'de> for F64Visitor {
    type Value = f64;

    fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
        write!(formatter, "a 64-bit floating point value")
    }

    fn visit_i8<E>(self, v: i8) -> Result<Self::Value, E>
        where E: de::Error
    {
        let v_ = v as f64;
        Ok(v_)
    }

    fn visit_i16<E>(self, v: i16) -> Result<Self::Value, E>
        where E: de::Error
    {
        let v_ = v as f64;
        Ok(v_)
    }

    fn visit_i32<E>(self, v: i32) -> Result<Self::Value, E>
        where E: de::Error
    {
        let v_ = v as f64;
        Ok(v_)
    }

    fn visit_i64<E>(self, v: i64) -> Result<Self::Value, E>
        where E: de::Error
    {
        let v_ = v as f64;
        Ok(v_)
    }

    fn visit_u8<E>(self, v: u8) -> Result<Self::Value, E>
        where E: de::Error
    {
        let v_ = v as f64;
        Ok(v_)
    }

    fn visit_u16<E>(self, v: u16) -> Result<Self::Value, E>
        where E: de::Error
    {
        let v_ = v as f64;
        Ok(v_)
    }

    fn visit_u32<E>(self, v: u32) -> Result<Self::Value, E>
        where E: de::Error
    {
        let v_ = v as f64;
        Ok(v_)
    }

    fn visit_u64<E>(self, v: u64) -> Result<Self::Value, E>
        where E: de::Error
    {
        let v_ = v as f64;
        Ok(v_)
    }

    fn visit_f64<E>(self, v: f64) -> Result<Self::Value, E>
        where E: de::Error
    {
        Ok(v)
    }
}


#[derive(Clone, Debug, PartialEq)]
pub struct Weight(Kilogram<f64>);

impl Weight {
    pub fn new(val: Kilogram<f64>) -> Weight {
        Weight(val)
    }
}

impl <'de> Deserialize<'de> for Weight {
    fn deserialize<D>(deserializer: D) -> Result<Weight, D::Error>
        where D: Deserializer<'de>
    {
        let val = deserializer.deserialize_f64(F64Visitor)?;
        Ok(Weight(val * KG))
    }
}

impl Serialize for Weight {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
        where S: Serializer
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

