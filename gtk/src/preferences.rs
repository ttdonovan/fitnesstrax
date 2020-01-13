use chrono_tz::Tz;

#[derive(Clone, Debug)]
pub struct Preferences {
    pub language: String,
    pub timezone: Tz,
    pub units: String,
}
