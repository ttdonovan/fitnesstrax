use serde::{Deserialize, Serialize};
use std::env;
use std::fs::File;
use std::io::Write;
use std::path;

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Configuration {
    pub series_path: path::PathBuf,
    pub language: String,
    pub timezone: chrono_tz::Tz,
    pub units: String,
}

impl Configuration {
    pub fn load_from_yaml() -> Configuration {
        let config_path = env::var("CONFIG").unwrap_or("config.yaml".to_string());
        let config_file = File::open(config_path.clone())
            .expect(&format!("cannot open configuration file: {}", &config_path));
        serde_yaml::from_reader(config_file).expect("invalid configuration file")
    }

    pub fn save_to_yaml(&self) {
        let config_path = env::var("CONFIG").unwrap_or("config.yaml".to_string());
        let s = serde_yaml::to_string(&self).unwrap();
        let mut config_file = File::create(config_path.clone())
            .expect(&format!("cannot open configuration file: {}", &config_path));
        let _ = config_file.write(s.as_bytes());
    }
}
