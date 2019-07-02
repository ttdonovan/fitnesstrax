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
export const Running = new Message("Running", { eo: "Kurado" })
export const TimeEntryPlaceholder = new Message("Enter time [hh:mm:ss]", {
  eo: "Eniru tempon [hh:mm:ss]",
})
export const Timezone = new Message("Timezone", { eo: "Horzono" })
export const WeightEntryPlaceholder = new Message("Enter weight", {
  eo: "Eniru pezon",
})
export const kilograms = new Message("kilograms", { eo: "kilogramoj" })
export const kilometers = new Message("kilometers", { eo: "kilometroj" })
export const miles = new Message("miles", { eo: "mejloj" })
export const pounds = new Message("pounds", { eo: "funtoj" })
export const stones = new Message("stones", { eo: "ŝtonoj" })
