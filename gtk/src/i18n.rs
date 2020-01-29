use fluent::{FluentBundle, FluentResource};
use std::borrow::Cow;
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
swimming = Naĝado
timezone = Horzono
units = Unuoj
walking = Promenadi
weight = Pezon
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

    pub fn edit(&self) -> Cow<str> {
        self.tr("edit").unwrap()
    }

    pub fn history(&self) -> Cow<str> {
        self.tr("history").unwrap()
    }

    pub fn preferences(&self) -> Cow<str> {
        self.tr("preferences").unwrap()
    }

    pub fn tr(&self, id: &str) -> Option<Cow<str>> {
        let mut _errors = vec![];

        self.bundle
            .get_message(id)
            .and_then(|msg| msg.value)
            .map(|pattern| self.bundle.format_pattern(&pattern, None, &mut _errors))
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
