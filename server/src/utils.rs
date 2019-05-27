use std::fs;
use std::path;

pub struct CleanupFile(pub path::PathBuf);

impl Drop for CleanupFile {
    fn drop(&mut self) {
        fs::remove_file(&self.0).expect("file remove should succeed");
    }
}
