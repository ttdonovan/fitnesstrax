import { English, Esperanto, languageFromSymbol } from "./languages"
import Option from "../option"

describe("Language lookup from symbol", () => {
  it("looks up English", () =>
    expect(languageFromSymbol("en")).toEqual(Option.Some(English)))

  it("looks up Esperanto", () =>
    expect(languageFromSymbol("eo")).toEqual(Option.Some(Esperanto)))
})
