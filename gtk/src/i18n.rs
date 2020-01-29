use fluent::{FluentArgs, FluentBundle, FluentResource, FluentValue};
use std::fmt;
use std::sync::Arc;
use unic_langid::LanguageIdentifier;

const ENGLISH_STRINGS: &str = "
add-workout = Add Workout
cancel = Cancel
cycling = Cycling
edit = Edit
enter-distance = Enter distance
enter-duration = Enter duration
enter-time = Enter time
health-tracker = Health Tracker
history = History
language = Language
preferences = Preferences
pushups = Pushups
running = Running
save = Save
situps = Situps
steps = Steps
step-count = {$count ->
    [one] 1 Step
    *[other] {$count} Steps
}
swimming = Swimming
timezone = Timezone
units = Units
walking = Walking
weight = Weight
";

const ESPERANTO_STRINGS: &str = "
add-workout = Aldonu Entrenamiento
cancel = Nuligi
cycling = Biciklado
edit = Redaktu
enter-distance = Eniru distanco
enter-duration = Eniru daŭro
enter-time = Eniru tempon
health-tracker = Sana Supuristo
history = Historio
language = Lingvo
preferences = Agdoroj
pushups = Supraj Puŝoj
running = Kurado
save = Ŝpari
situps = Sidiĝoj
steps = Paŝoj
step-count = {$count ->
    [one] 1 Paŝo
    *[other] {$count} Paŝoj
}
swimming = Naĝado
timezone = Horzono
units = Unuoj
walking = Promenadi
weight = Pezo
";

#[derive(Clone)]
pub struct Messages {
    language: LanguageIdentifier,
    bundle: Arc<FluentBundle<FluentResource>>,
}

impl fmt::Debug for Messages {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "Messages {{ language: {}, bundle }}", self.language)
    }
}

impl Messages {
    pub fn new(lang_str: &str) -> Messages {
        let english_id = "en".parse().expect("Parsing failed");
        let langid: LanguageIdentifier = lang_str.parse().expect("Parsing failed");

        let mut bundle = FluentBundle::new(&[langid.clone(), english_id]);

        let res = match lang_str {
            "eo" => FluentResource::try_new(String::from(ESPERANTO_STRINGS))
                .expect("Esperanto strings do not load"),
            _ => FluentResource::try_new(String::from(ENGLISH_STRINGS))
                .expect("English strings do not load"),
        };
        bundle
            .add_resource(res)
            .expect("failed to add English to the bundle");

        Messages {
            language: langid,
            bundle: Arc::new(bundle),
        }
    }

    pub fn cancel(&self) -> String {
        self.tr("cancel").unwrap()
    }

    pub fn cycling(&self) -> String {
        self.tr("cycling").unwrap()
    }

    pub fn edit(&self) -> String {
        self.tr("edit").unwrap()
    }

    pub fn history(&self) -> String {
        self.tr("history").unwrap()
    }

    pub fn preferences(&self) -> String {
        self.tr("preferences").unwrap()
    }

    pub fn rowing(&self) -> String {
        self.tr("rowing").unwrap()
    }

    pub fn running(&self) -> String {
        self.tr("running").unwrap()
    }

    pub fn save(&self) -> String {
        self.tr("save").unwrap()
    }

    pub fn step_count(&self, count: u32) -> String {
        let mut _errors = vec![];

        let mut args = FluentArgs::new();
        args.insert("count", FluentValue::from(count));

        self.bundle
            .get_message("step-count")
            .and_then(|msg| msg.value)
            .map(move |pattern| {
                String::from(
                    self.bundle
                        .format_pattern(&pattern, Some(&args), &mut _errors),
                )
            })
            .unwrap()
    }

    pub fn swimming(&self) -> String {
        self.tr("swimming").unwrap()
    }

    pub fn walking(&self) -> String {
        self.tr("walking").unwrap()
    }

    pub fn tr(&self, id: &str) -> Option<String> {
        let mut _errors = vec![];

        self.bundle
            .get_message(id)
            .and_then(|msg| msg.value)
            .map(|pattern| String::from(self.bundle.format_pattern(&pattern, None, &mut _errors)))
    }
}

#[cfg(test)]
mod test {
    use super::Messages;

    #[test]
    fn translations_work() {
        let en = Messages::new("en-US");
        assert_eq!(en.tr("preferences"), Some("Preferences"));

        let eo = Messages::new("eo");
        assert_eq!(eo.tr("preferences"), Some("Agdoroj"));
        assert_eq!(eo.tr("historio"), None);
    }
}
