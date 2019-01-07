
use chrono::prelude::*;
use dimensioned::si::{ M, Meter, S, Second };
use emseries::{ Recordable };
use serde::de;
use serde::de::{ Deserialize, Deserializer, MapAccess, Visitor };
use serde::ser::{ Serialize, Serializer, SerializeStruct };
use std::fmt;

#[derive(Clone, Debug, PartialEq, Deserialize, Serialize)]
pub enum ActivityType {
    Cycling,
    Running,
}


#[derive(Clone, Debug, PartialEq)]
pub struct TimeDistance {
    pub activity: ActivityType,
    pub comments: Option<String>,
    pub distance: Option<Meter<f64>>,
    pub duration: Option<Second<f64>>,
    pub timestamp: DateTime<Utc>,
}

impl TimeDistance {
    pub fn new(activity: ActivityType,
               comments: Option<String>,
               timestamp: DateTime<Utc>,
               distance: Option<Meter<f64>>,
               duration: Option<Second<f64>>) -> TimeDistance {
        TimeDistance{ activity, comments, timestamp, distance, duration }
    }
}

impl Recordable for TimeDistance {
    fn timestamp(&self) -> DateTime<Utc> {
        self.timestamp
    }

    fn tags(&self) -> Vec<String> {
        match self.activity {
            ActivityType::Cycling => vec![String::from("Cycling")],
            ActivityType::Running => vec![String::from("Running")]
        }
    }

    fn values(&self) -> Vec<String> {
        Vec::new()
    }
}

impl <'de> Deserialize<'de> for TimeDistance {
    fn deserialize<D>(deserializer: D) -> Result<TimeDistance, D::Error>
    where D: Deserializer<'de>
    {
        enum Field { Activity, Comments, Timestamp, Distance, Duration };
        impl <'de> Deserialize<'de> for Field {
            fn deserialize<D>(deserializer: D) -> Result<Field, D::Error>
            where D: Deserializer<'de>,
            {
                struct FieldVisitor;
                impl <'de> Visitor<'de> for FieldVisitor {
                    type Value = Field;
                    fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
                        formatter.write_str("`activity`, `comments`, timestamp`, `date`, `distance`, or `duration`")
                    }

                    fn visit_str<E>(self, value: &str) -> Result<Field, E>
                    where E: de::Error,
                    {
                        match value {
                            "activity" => Ok(Field::Activity),
                            "comments" => Ok(Field::Comments),
                            "timestamp" => Ok(Field::Timestamp),
                            "date" => Ok(Field::Timestamp),
                            "distance" => Ok(Field::Distance),
                            "duration" => Ok(Field::Duration),
                            _ => Err(de::Error::unknown_field(value, FIELDS)),
                        }
                    }
                }

                deserializer.deserialize_identifier(FieldVisitor)
            }
        }

        struct TimeDistanceVisitor;

        impl <'de> Visitor<'de> for TimeDistanceVisitor {
            type Value = TimeDistance;

            fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
                formatter.write_str("struct TimeDistance")
            }

            fn visit_map<V>(self, mut map: V) -> Result<TimeDistance, V::Error>
            where V: MapAccess<'de>,
            {
                let mut activity = None;
                let mut comments = None;
                let mut timestamp = None;
                let mut distance = None;
                let mut duration = None;
                while let Some(key) = map.next_key()? {
                    match key {
                        Field::Activity => { activity = Some(map.next_value()?); }
                        Field::Comments => { comments = map.next_value()?; },
                        Field::Timestamp => { timestamp = Some(map.next_value()?); },
                        Field::Distance => { distance = map.next_value::<Option<f64>>().map(|v| v.map(|v_| v_ * M))?; },
                        Field::Duration => { duration = map.next_value::<Option<f64>>().map(|v| v.map(|v_| v_ * S))?; },
                    }
                }
                let activity = activity.ok_or_else(|| de::Error::missing_field("activity"))?;
                let timestamp = timestamp.ok_or_else(|| de::Error::missing_field("timestamp"))?;
                Ok(TimeDistance{ activity, comments, distance, duration, timestamp })
            }
        }

        const FIELDS: &'static [&'static str] = &["activity", "comments", "timestamp", "date", "distance", "duration"];
        deserializer.deserialize_struct("TimeDistance", FIELDS, TimeDistanceVisitor)

    }
}

impl Serialize for TimeDistance {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
        where S: Serializer
    {
        let mut s = serializer.serialize_struct("TimeDistance", 5)?;
        s.serialize_field("activity", &self.activity)?;
        s.serialize_field("comments", &self.comments)?;
        s.serialize_field("date", &self.timestamp)?;
        s.serialize_field("distance", &self.distance.map(|v| v.value_unsafe))?;
        s.serialize_field("duration", &self.duration.map(|v| v.value_unsafe))?;
        s.end()
    }
}


