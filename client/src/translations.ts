import { keyBy } from "./common"
import Option from "./option"

export enum Language {
  English = "en",
  Esperanto = "eo",
}

type LanguageParam = {
  eo?: string
}

export class Message {
  constructor(readonly en: string, readonly translations: LanguageParam) {}

  tr(lang: Language): string {
    if (lang === Language.Esperanto) {
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
