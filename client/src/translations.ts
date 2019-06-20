import { keyBy } from "./common"
import Option from "./option"

import { Language, Esperanto } from "./settings"

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

export const HealthTracker = new Message("Health Tracker", {
  eo: "Sana Supuristo",
})
export const History = new Message("History", { eo: "Historio" })
export const LogIn = new Message("Log In", { eo: "Ensaluti" })
export const LoginPlaceholder = new Message("Enter your login token", {
  eo: "Eniru vian ensalutan ĵetono",
})
export const Preferences = new Message("Preferences", { eo: "Agordoj" })
export const Cycling = new Message("Cycling", { eo: "Biciklado" })
export const Running = new Message("Running", { eo: "Kurado" })
export const miles = new Message("miles", { eo: "mejloj" })
export const kilometers = new Message("kilometers", { eo: "kilometroj" })
export const pounds = new Message("pounds", { eo: "funtoj" })
export const stones = new Message("stones", { eo: "ŝtonoj" })
export const kilograms = new Message("kilograms", { eo: "kilogramoj" })
