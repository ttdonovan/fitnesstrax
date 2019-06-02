import moment from "moment-timezone"
import { withinDay } from "./moment-extensions"

describe("Verify date bounds", () => {
  it("can determine that noon UTC is within a day", () => {
    expect(
      withinDay(moment("2019-01-01T00:00:00Z"), moment("2019-01-01T12:00:00Z")),
    ).toBe(true)

    expect(
      withinDay(moment("2019-01-01T00:00:00Z"), moment("2019-01-02T12:00:00Z")),
    ).toBe(false)

    expect(
      withinDay(moment("2019-01-01T00:00:00Z"), moment("2018-12-31T12:00:00Z")),
    ).toBe(false)
  })

  it("can determine that midnight UTC is within a day", () => {
    expect(
      withinDay(moment("2019-01-01T00:00:00Z"), moment("2019-01-01T00:00:00Z")),
    ).toBe(true)

    expect(
      withinDay(moment("2019-01-01T00:00:00Z"), moment("2019-01-02T00:00:00Z")),
    ).toBe(false)

    expect(
      withinDay(moment("2019-01-01T00:00:00Z"), moment("2018-12-31T00:00:00Z")),
    ).toBe(false)
  })

  it("can determine that a time is within a day", () => {
    const reference = moment("2019-01-01T00:00:00Z")

    expect(withinDay(reference, moment("2019-01-01T05:00:00+0500"))).toBe(true)
    expect(withinDay(reference, moment("2019-01-01T20:00:00-0400"))).toBe(false)
  })

  it("can compare a date against the current time zone", () => {
    const reference = moment("2019-01-01T00:00:00-0400")

    expect(withinDay(reference, moment("2019-01-02T03:59:59Z"))).toBe(true)
    expect(withinDay(reference, moment("2019-01-02T05:00:00Z"))).toBe(false)
    expect(withinDay(reference, moment("2019-01-01T04:00:00Z"))).toBe(true)
    expect(withinDay(reference, moment("2019-01-01T03:59:59Z"))).toBe(false)
  })

  it("compares some real dates", () => {
    const reference = moment("2017-10-28T00:00:00Z")

    console.log(reference.rfc3339())

    expect(withinDay(reference, moment("2017-10-28T11:25:00-0500"))).toBe(true)
    expect(withinDay(reference, moment("2017-10-28T02:27:00-0500"))).toBe(true)
    expect(withinDay(reference, moment("2017-10-28T05:22:00-0500"))).toBe(true)
  })
})
