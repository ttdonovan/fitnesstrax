use dimensioned::si::Kilogram;
use fluent::{FluentArgs, FluentBundle, FluentResource, FluentValue};
use std::fmt;
use std::sync::Arc;
use unic_langid::LanguageIdentifier;

use crate::i18n::UnitSystem;

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
mass = {$units ->
    *[SI] {$value} kilograms
    [USA] {$value} pounds
}
mass-label = {$units ->
    *[SI] kilograms
    [USA] pounds
}
preferences = Preferences
pushups = Pushups
running = Running
save = Save
situps = Situps
steps = Steps
step-count = {$count ->
    [one] 1 step
    *[other] {$count} steps
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
mass = {$units ->
    *[SI] {$value} kilogramoj
    [USA] {$value} funtoj
}
mass-label = {$units ->
    *[SI] kilogramoj
    [USA] funtoj
}
preferences = Agdoroj
pushups = Supraj Puŝoj
running = Kurado
save = Ŝpari
situps = Sidiĝoj
steps = Paŝoj
step-count = {$count ->
    [one] 1 paŝo
    *[other] {$count} paŝoj
}
swimming = Naĝado
timezone = Horzono
units = Unuoj
walking = Promenadi
weight = Pezo
";

#[derive(Clone)]
pub struct Text {
    language: LanguageIdentifier,
    units: UnitSystem,
    bundle: Arc<FluentBundle<FluentResource>>,
}

impl fmt::Debug for Text {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "Text {{ language: {}, units: {} }}",
            self.language, "whatever, for the moment"
        )
    }
}

fn add_language(bundle: &mut FluentBundle<FluentResource>, langid: &LanguageIdentifier) {
    let lang_resource = match langid.get_language() {
        "en" => FluentResource::try_new(String::from(ENGLISH_STRINGS)),
        "eo" => FluentResource::try_new(String::from(ESPERANTO_STRINGS)),
        _ => panic!("unsupported language"),
    };
    match lang_resource {
        Ok(res) => {
            let _ = bundle.add_resource(res);
        }
        Err(err) => panic!("{:?}", err),
    }
}

impl Text {
    pub fn new(langid: LanguageIdentifier, units: UnitSystem) -> Text {
        let english_id: LanguageIdentifier = "en".parse().unwrap();
        let mut bundle = FluentBundle::new(&[langid.clone(), english_id.clone()]);

        add_language(&mut bundle, &langid);
        add_language(&mut bundle, &english_id);

        Text {
            language: langid.clone(),
            units,
            bundle: Arc::new(bundle),
        }
    }

    pub fn language_id(&self) -> &str {
        self.language.get_language()
    }

    pub fn cancel(&self) -> String {
        self.tr("cancel", None).unwrap()
    }

    pub fn cycling(&self) -> String {
        self.tr("cycling", None).unwrap()
    }

    pub fn edit(&self) -> String {
        self.tr("edit", None).unwrap()
    }

    pub fn history(&self) -> String {
        self.tr("history", None).unwrap()
    }

    pub fn language(&self) -> String {
        self.tr("language", None).unwrap()
    }

    pub fn mass(&self, value: &Kilogram<f64>) -> String {
        let mut args = FluentArgs::new();
        args.insert(
            "value",
            FluentValue::from(format!("{:.1}", self.units.mass(&value))),
        );
        args.insert("units", FluentValue::from(String::from(&self.units)));

        self.tr("mass", Some(&args)).unwrap()
    }

    pub fn mass_label(&self) -> String {
        self.tr("mass-label", None).unwrap()
    }

    pub fn preferences(&self) -> String {
        self.tr("preferences", None).unwrap()
    }

    pub fn rowing(&self) -> String {
        self.tr("rowing", None).unwrap()
    }

    pub fn running(&self) -> String {
        self.tr("running", None).unwrap()
    }

    pub fn save(&self) -> String {
        self.tr("save", None).unwrap()
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

    pub fn steps_label(&self) -> String {
        self.tr("steps", None).unwrap()
    }

    pub fn swimming(&self) -> String {
        self.tr("swimming", None).unwrap()
    }

    pub fn timezone(&self) -> String {
        self.tr("timezone", None).unwrap()
    }

    pub fn units(&self) -> String {
        self.tr("units", None).unwrap()
    }

    pub fn walking(&self) -> String {
        self.tr("walking", None).unwrap()
    }

    pub fn tr(&self, id: &str, args: Option<&FluentArgs>) -> Option<String> {
        let mut _errors = vec![];

        self.bundle
            .get_message(id)
            .and_then(|msg| msg.value)
            .map(|pattern| String::from(self.bundle.format_pattern(&pattern, args, &mut _errors)))
    }
}

#[cfg(test)]
mod test {
    use super::Text;

    #[test]
    fn translations_work() {
        let en = Text::new("en-US");
        assert_eq!(en.tr("preferences"), Some("Preferences"));

        let eo = Text::new("eo");
        assert_eq!(eo.tr("preferences"), Some("Agdoroj"));
        assert_eq!(eo.tr("historio"), None);
    }
}
