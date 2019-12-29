use crate::range::Range;
use chrono;
use chrono_tz;

pub type DateRange = Range<chrono::Date<chrono_tz::Tz>>;
