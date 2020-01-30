mod basics;
mod date_selector;
mod day;
mod history;
mod main_window;
mod preferences;
mod range_selector;
mod rep_duration;
mod set_rep;
mod setting;
mod steps;
mod swappable;
mod time_distance;
mod time_distance_row;
mod validated_text_entry;
mod weight;

pub use basics::*;
pub use date_selector::date_selector_c;
pub use day::Day;
pub use history::History;
pub use main_window::MainWindow;
pub use preferences::Preferences;
pub use range_selector::RangeSelector;
pub use setting::setting_c;
pub use swappable::SwappableComponent;
pub use validated_text_entry::validated_text_entry_c;

pub trait Component {
    fn render(&self) -> gtk::Box;
}
