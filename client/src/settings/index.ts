import { Option } from "ld-ambiguity"
import { IANAZone } from "luxon"

import { UnitSystem } from "./unitSystems"
import { Language } from "../i18n"

export * from "./unitSystems"

export class UserPreferences {
  constructor(
    readonly timezone: IANAZone,
    readonly units: UnitSystem,
    readonly language: Language,
  ) {}

  withTimezone = (tz: IANAZone): UserPreferences =>
    new UserPreferences(tz, this.units, this.language)

  withUnits = (units: UnitSystem): UserPreferences =>
    new UserPreferences(this.timezone, units, this.language)

  withLanguage = (lang: Language): UserPreferences =>
    new UserPreferences(this.timezone, this.units, lang)
}
