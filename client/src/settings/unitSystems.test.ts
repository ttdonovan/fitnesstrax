import * as i18n from "../i18n"
import * as units from "./unitSystems"

describe("unitSystems", () => {
  it("is fully defined", () => {
    expect(units.SI.sym).toEqual("SI")
    expect(units.SI.lengthRepr.tr(i18n.English)).toEqual("kilometers")
  })
})
