// Unifying i18n. This is mostly concerned with parsing and generating strings. Parsing is
// generally not for freeform strings but for structured values such as numbers, dates, and times.

mod text;
mod units;

pub use text::Text;
pub use units::UnitSystem;
