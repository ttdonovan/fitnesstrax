use emseries::{DateTimeTz, Recordable};

#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
pub struct Steps(u32);

impl Steps {
    pub fn new(val: u32) -> Steps {
        Steps(val)
    }
}

#[derive(Clone, Debug, PartialEq, Deserialize, Serialize)]
pub struct StepRecord {
    date: DateTimeTz,
    steps: Steps,
}

impl StepRecord {
    pub fn new(date: DateTimeTz, steps: u32) -> StepRecord {
        StepRecord {
            date,
            steps: Steps::new(steps),
        }
    }
}

impl Recordable for StepRecord {
    fn timestamp(&self) -> DateTimeTz {
        self.date.clone()
    }

    fn tags(&self) -> Vec<String> {
        Vec::new()
    }
}
