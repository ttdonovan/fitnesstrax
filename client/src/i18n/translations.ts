import { Language, Esperanto } from "./languages"

type LanguageParam = {
  eo?: string
}

export class Message {
  constructor(readonly en: string, readonly translations: LanguageParam) {}

  tr(lang: Language): string {
    if (lang === Esperanto) {
      return this.translations.eo || this.en
    }
    return this.en
  }
}

export const AddWorkout = new Message("Add Workout", {
  eo: "Aldonu Entrenamiento",
})
export const Cancel = new Message("Cancel", { eo: "Nuligi" })
export const Cycling = new Message("Cycling", { eo: "Biciklado" })
export const DistanceEntryPlaceholder = new Message(
  "Enter distance [hh:mm:ss]",
  {
    eo: "Eniru distanco",
  },
)
export const DurationEntryPlaceholder = new Message(
  "Enter duration [hh:mm:ss]",
  {
    eo: "Eniru daŭro [hh:mm:ss]",
  },
)
export const HealthTracker = new Message("Health Tracker", {
  eo: "Sana Supuristo",
})
export const History = new Message("History", { eo: "Historio" })
export const LanguageString = new Message("Language", { eo: "Lingvo" })
export const UnitsString = new Message("Units", { eo: "Unuoj" })
export const LogIn = new Message("Log In", { eo: "Ensaluti" })
export const LoginPlaceholder = new Message("Enter your login token", {
  eo: "Eniru vian ensalutan ĵetono",
})
export const Preferences = new Message("Preferences", { eo: "Agordoj" })
export const Steps = new Message("Steps", { eo: "Paŝoj" })
export const Running = new Message("Running", { eo: "Kurado" })
export const Save = new Message("Save", { eo: "Ŝpari" })
export const Swimming = new Message("Swimming", { eo: "Naĝado" })
export const TimeEntryPlaceholder = new Message("Enter time [hh:mm:ss]", {
  eo: "Eniru tempon [hh:mm:ss]",
})
export const Timezone = new Message("Timezone", { eo: "Horzono" })
export const Walking = new Message("Walking", { eo: "Promenadi" })
export const Weight = new Message("Weight", {
  eo: "Pezon",
})
export const kilograms = new Message("kg", { eo: "kg" })
export const kilometers = new Message("km", { eo: "km" })
export const miles = new Message("mi", { eo: "me" })
export const pounds = new Message("lbs", {})
export const stones = new Message("st", { eo: "ŝt" })
