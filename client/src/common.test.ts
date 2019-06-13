//import moment from "moment-timezone"

import { keyBy, parseDTZ } from "./common"

import trace from "./trace"
import Option from "./option"

describe("keyBy", () => {
  it("should group things by the grouping function", () => {
    const lst: Array<{ key: string; val: string }> = [
      { key: "a", val: "aaaa" },
      { key: "b", val: "bbbb" },
      { key: "c", val: "cccc" },
      { key: "a", val: "dddd" },
    ]
    const res = keyBy((i: { key: string; val: string }): string => i.key)(lst)
    expect(res.get("a")).toHaveLength(2)
    expect(res.get("a")).toContainEqual({ key: "a", val: "aaaa" })
    expect(res.get("a")).toContainEqual({ key: "a", val: "dddd" })
    expect(res.get("b")).toHaveLength(1)
    expect(res.get("b")).toContainEqual({ key: "b", val: "bbbb" })
  })
})

/* These verify that I can get the original date back without a timezone
 * conversion. It is not a test of my code, just my assumptions. */
  /*
describe("datetime management", () => {
  xit("timezone printing", () => {
    console.log(
      moment("2019-05-15T12:00:00Z")
        .tz("US/Central")
        .format(),
    )
    console.log(
      moment("2019-05-15T12:00:00Z")
        .tz("US/Central")
        .utc()
        .format(),
    )
    console.log(
      moment("2019-05-15T04:00:00Z")
        .tz("US/Central")
        .startOf("day")
        .format(),
    )
    console.log(
      moment("2019-05-15T04:00:00Z")
        .tz("US/Central")
        .utc()
        .startOf("day")
        .format(),
    )
    console.log(
      moment("2019-05-15T04:00:00Z")
        .tz("US/Central")
        .tz(),
    )

    console.log(moment("2019-05-14T23:00:00-0500").format())
    console.log(moment("2019-05-14T23:00:00-0500").tz())
    console.log(moment("2019-05-14T23:00:00CDT").tz())
  })

  it("parses utc rfc3339 with z", () => {
    const dtz = parseDTZ("2019-05-15T12:00:00Z")
    expect(dtz).toEqual(Option.Some(moment("2019-05-15T12:00:00Z")))
  })

  it("parses rfc3339 with offset", () => {
    const dtz = parseDTZ("2019-05-15T12:00:00-06:00")
    expect(dtz.map(dt => dt.isSame(moment("2019-05-15T18:00:00Z")))).toEqual(
      Option.Some(true),
    )
  })

  it("parses rfc3339 with timezone", () => {
    const dtz = parseDTZ("2019-06-15T19:00:00Z @ US/Arizona")
    expect(dtz.map(dt => dt.isSame(moment("2019-06-15T19:00:00Z")))).toEqual(
      Option.Some(true),
    )
  })

  it("works with UTC times", () => {
    const base = moment("2019-06-02T04:13:00Z")
    console.log(base)
    console.log(base.format("YYYY-MM-DD"))
    console.log(base.startOf("day").format("YYYY-MM-DD"))
    expect(base.utc().format("YYYY-MM-DD")).toEqual("2019-06-02")
  })

  xit("works with reference to the stated time zone", () => {
    const base = moment("2019-06-02T04:13:00-0600")
    expect(base.format("YYYY-MM-DD")).toEqual("2019-06-02")
  })
})
   */
