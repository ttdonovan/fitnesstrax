use serde::{Deserialize, Serialize};
use std::env;
use std::fs::File;
use std::path;

#[derive(Debug, Serialize, Deserialize)]
pub struct Configuration {
    pub series_path: path::PathBuf,
    pub timezone: chrono_tz::Tz,
    pub language: String,
}

impl Configuration {
    pub fn load_from_yaml() -> Configuration {
        let config_path = env::var("CONFIG").unwrap_or("config.yaml".to_string());
        let config_file = File::open(config_path.clone())
            .expect(&format!("cannot open configuration file: {}", &config_path));
        serde_yaml::from_reader(config_file).expect("invalid configuration file")
    }
}
