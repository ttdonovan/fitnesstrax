import _ from "lodash/fp"
import { first } from "../common"

import Option from "../option"

export class Language {
  constructor(readonly sym: string, readonly name: string) {}
}

export const English = new Language("en", "English")
export const Esperanto = new Language("eo", "Esperanto")

export const Languages: Array<Language> = [English, Esperanto]

export const languageFromSymbol = (s: string): Option<Language> =>
  first(_.filter((lang: Language): boolean => lang.sym === s)(Languages))
