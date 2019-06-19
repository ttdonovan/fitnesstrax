import * as msgs from "./translations"
import Option from "./option"

const EdgeCase = new msgs.Message("EdgeCase", {})

describe("Translations", () => {
  it("does a successful lookup", () => {
    expect(msgs.History.tr(msgs.Language.Esperanto)).toEqual("Historio")
  })

  it("returns english for an untranslated string", () => {
    expect(EdgeCase.tr(msgs.Language.Esperanto)).toEqual("EdgeCase")
  })
})
