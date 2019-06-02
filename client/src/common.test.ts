import moment from "moment-timezone"
import { dateToDay } from "./moment-extensions"

import { keyBy } from "./common"

describe("date time handling", () => {
  it("parses timezones reasonably", () => {
    expect(moment("2018-10-10T04:00:00Z").rfc3339()).toEqual(
      "2018-10-10T04:00:00Z",
    )
  })
})

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

// VERY IMPORTANT: keying by moment.Moment does not work. I assume it is
// because moment.Moment does not implement any standard equality operator.
const bucketByDay = (
  recs: Array<moment.Moment>,
): Map<string, Array<moment.Moment>> =>
  keyBy((r: moment.Moment) => dateToDay(r).format())(recs)

describe("bucketByDay", () => {
  const reference = moment("2017-10-28T00:00:00-0500")

  const lst: Array<moment.Moment> = [
    moment("2017-10-28T11:25:00-0500"),
    moment("2017-10-28T02:27:00-0500"),
    moment("2017-10-28T05:22:00-0500"),
  ]

  const res = bucketByDay(lst)
  expect(res.get(reference.format())).toHaveLength(3)
})
