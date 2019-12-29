use emseries::{DateTimeTz, Recordable};

#[derive(Clone, Debug, PartialEq, Deserialize, Serialize)]
pub struct StepRecord {
    date: DateTimeTz,
    pub steps: u32,
}

impl StepRecord {
    pub fn new(date: DateTimeTz, steps: u32) -> StepRecord {
        StepRecord { date, steps }
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
