import { toRfc3339 } from "./common"
import moment from "moment-timezone"

describe("date time handling", () => {
  it("parses timezones reasonably", () => {
    expect(toRfc3339(moment("2018-10-10T04:00:00Z"))).toEqual(
      "2018-10-10T04:00:00Z",
    )
  })
})
