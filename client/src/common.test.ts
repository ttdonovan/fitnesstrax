import moment from "moment-timezone"
import "./moment-extensions"

describe("date time handling", () => {
  it("parses timezones reasonably", () => {
    expect(moment("2018-10-10T04:00:00Z").rfc3339()).toEqual(
      "2018-10-10T04:00:00Z",
    )
  })
})
