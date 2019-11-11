pub fn steps_c(record: &fitnesstrax::steps::StepRecord) -> gtk::Label {
    gtk::Label::new(Some(&format!("{} Steps", record.steps)))
}
