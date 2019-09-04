use dimensioned::si::Second;
use emseries::{DateTimeTz, Recordable};

#[derive(Clone, Debug, PartialEq, Deserialize, Serialize)]
pub enum ActivityType {
    MartialArts,
    Planks,
    Yoga,
}

#[derive(Clone, Debug, PartialEq, Deserialize, Serialize)]
pub struct RepDurationRecord {
    #[serde(rename = "date")]
    pub timestamp: DateTimeTz,
    pub activity: ActivityType,
    pub sets: Vec<Second<f64>>,
    pub comments: Option<String>,
}

impl RepDurationRecord {
    pub fn new(
        timestamp: DateTimeTz,
        activity: ActivityType,
        sets: Vec<Second<f64>>,
        comments: Option<String>,
    ) -> RepDurationRecord {
        RepDurationRecord {
            timestamp,
            activity,
            sets,
            comments,
        }
    }
}

impl Recordable for RepDurationRecord {
    fn timestamp(&self) -> DateTimeTz {
        self.timestamp.clone()
    }

    fn tags(&self) -> Vec<String> {
        match self.activity {
            ActivityType::MartialArts => vec![String::from("MartialArts")],
            ActivityType::Planks => vec![String::from("Planks")],
            ActivityType::Yoga => vec![String::from("Yoga")],
        }
    }
}
