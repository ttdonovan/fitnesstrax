use dimensioned::si::{Meter, Second};
use emseries::{DateTimeTz, Recordable};

#[derive(Clone, Debug, PartialEq, Deserialize, Serialize)]
pub enum ActivityType {
    Cycling,
    Rowing,
    Running,
    Swimming,
    Walking,
}

pub type TimeDistanceRecord = TimeDistance;

#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
pub struct TimeDistance {
    #[serde(rename = "date")]
    timestamp: DateTimeTz,
    activity: ActivityType,
    distance: Option<Meter<f64>>,
    duration: Option<Second<f64>>,
    comments: Option<String>,
}

impl TimeDistance {
    pub fn new(
        timestamp: DateTimeTz,
        activity: ActivityType,
        distance: Option<Meter<f64>>,
        duration: Option<Second<f64>>,
        comments: Option<String>,
    ) -> TimeDistance {
        TimeDistance {
            timestamp,
            activity,
            distance,
            duration,
            comments,
        }
    }
}

impl Recordable for TimeDistance {
    fn timestamp(&self) -> DateTimeTz {
        self.timestamp.clone()
    }

    fn tags(&self) -> Vec<String> {
        match self.activity {
            ActivityType::Cycling => vec![String::from("Cycling")],
            ActivityType::Rowing => vec![String::from("Rowing")],
            ActivityType::Running => vec![String::from("Running")],
            ActivityType::Swimming => vec![String::from("Swimming")],
            ActivityType::Walking => vec![String::from("Walking")],
        }
    }
}

#[cfg(test)]
mod test {
    use super::{ActivityType, TimeDistance};
    use dimensioned::si::{M, S};

    #[test]
    pub fn deserialize_time_distance() {
        let cycling_track_str = "{\"data\":{\"distance\":12200,\"date\":\"2017-10-28T19:27:00Z\",\"activity\":\"Cycling\",\"comments\":null,\"duration\":3120},\"id\":\"27ca887e-72c7-4d51-b7e4-6dca849a8f72\"}";
        let cycle_track: emseries::Record<TimeDistance> =
            serde_json::from_str(cycling_track_str).unwrap();
        assert_eq!(cycle_track.data.activity, ActivityType::Cycling);
        assert_eq!(cycle_track.data.distance, Some(12200. * M));
        assert_eq!(cycle_track.data.duration, Some(3120. * S));

        let running_track_str = "{\"data\":{\"distance\":3630,\"date\":\"2018-11-12T18:30:00Z\",\"activity\":\"Running\",\"comments\":null,\"duration\":1800}, \"id\":\"680c3306-991c-4edf-9635-c9d2fd72686f\"}";
        let running_track: Result<emseries::Record<TimeDistance>, serde_json::Error> =
            serde_json::from_str(running_track_str);
        match running_track {
            Ok(track) => {
                assert_eq!(track.data.activity, ActivityType::Running);
                assert_eq!(track.data.distance, Some(3630. * M));
                assert_eq!(track.data.duration, Some(1800. * S));
            }
            Err(err) => panic!(err),
        }
    }
}
