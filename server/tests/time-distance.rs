extern crate dimensioned;
extern crate serde_json;

extern crate emseries;
extern crate fitnesstrax;

use dimensioned::si::{ M, S };


#[test]
pub fn deserialize_time_distance() {
    let cycling_track_str = "{\"data\":{\"distance\":12200,\"date\":\"2017-10-28T19:27:00Z\",\"activity\":\"Cycling\",\"comments\":null,\"duration\":3120},\"id\":\"27ca887e-72c7-4d51-b7e4-6dca849a8f72\"}";
    let cycle_track: Result<emseries::Record<fitnesstrax::TimeDistance>, serde_json::Error> = serde_json::from_str(cycling_track_str);
    match cycle_track {
        Ok(track) => {
            assert_eq!(track.data.activity, fitnesstrax::ActivityType::Cycling);
            assert_eq!(track.data.distance, Some(12200. * M));
            assert_eq!(track.data.duration, Some(3120. * S));
        },
        Err(err) => panic!(err)
    }

    let running_track_str = "{\"data\":{\"distance\":3630,\"date\":\"2018-11-12T18:30:00Z\",\"activity\":\"Running\",\"comments\":null,\"duration\":1800}, \"id\":\"680c3306-991c-4edf-9635-c9d2fd72686f\"}";
    let running_track: Result<emseries::Record<fitnesstrax::TimeDistance>, serde_json::Error> = serde_json::from_str(running_track_str);
    match running_track {
        Ok(track) => {
            assert_eq!(track.data.activity, fitnesstrax::ActivityType::Running);
            assert_eq!(track.data.distance, Some(3630. * M));
            assert_eq!(track.data.duration, Some(1800. * S));
        },
        Err(err) => panic!(err)
    }
}

