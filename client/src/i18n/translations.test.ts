import { Option } from "ld-ambiguity"

import * as msgs from "./translations"
import { English, Esperanto } from "./languages"

const EdgeCase = new msgs.Message("EdgeCase", {})

describe("Translations", () => {
  it("does a successful lookup", () => {
    expect(msgs.History.tr(Esperanto)).toEqual("Historio")
  })

  it("returns english for an untranslated string", () => {
    expect(EdgeCase.tr(Esperanto)).toEqual("EdgeCase")
  })
})
