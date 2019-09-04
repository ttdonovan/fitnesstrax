use emseries::{DateTimeTz, Recordable};

#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
pub struct Comments {
    date: DateTimeTz,
    val: String,
}

impl Comments {
    pub fn new(date: DateTimeTz, val: &str) -> Comments {
        Comments {
            date,
            val: String::from(val),
        }
    }
}

impl Recordable for Comments {
    fn timestamp(&self) -> DateTimeTz {
        self.date.clone()
    }

    fn tags(&self) -> Vec<String> {
        Vec::new()
    }
}
