use emseries::{DateTimeTz, Recordable};
use trax::Error;

#[derive(Clone, Debug, PartialEq, Deserialize, Serialize)]
pub enum ActivityType {
    Pushups,
    Situps,
    Squats,
}

#[derive(Clone, Debug, PartialEq, Deserialize, Serialize)]
pub struct SetRepRecord {
    #[serde(rename = "date")]
    pub timestamp: DateTimeTz,
    pub activity: ActivityType,
    pub sets: Vec<u32>,
    pub comments: Option<String>,
}

impl SetRepRecord {
    pub fn new(
        timestamp: DateTimeTz,
        activity: ActivityType,
        sets: Vec<u32>,
        comments: Option<String>,
    ) -> Result<SetRepRecord, Error> {
        if sets.iter().all(|&x| x > 0) {
            Ok(SetRepRecord {
                timestamp,
                activity,
                sets,
                comments,
            })
        } else {
            Err(Error::InvalidParameter)
        }
    }
}

impl Recordable for SetRepRecord {
    fn timestamp(&self) -> DateTimeTz {
        self.timestamp.clone()
    }

    fn tags(&self) -> Vec<String> {
        match self.activity {
            ActivityType::Pushups => vec![String::from("Pushups")],
            ActivityType::Situps => vec![String::from("Situps")],
            ActivityType::Squats => vec![String::from("Squats")],
        }
    }
}
