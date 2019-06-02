import moment from "moment-timezone"
import { midnight } from "./moment-extensions"

import { keyBy } from "./common"

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
  keyBy((r: moment.Moment) => midnight(r).rfc3339())(recs)

describe("bucketByDay", () => {
  const reference = moment("2017-10-28T00:00:00-0500")

  const lst: Array<moment.Moment> = [
    moment("2017-10-28T11:25:00-0500"),
    moment("2017-10-28T02:27:00-0500"),
    moment("2017-10-28T05:22:00-0500"),
  ]

  const res = bucketByDay(lst)
  console.log(reference.rfc3339())
  console.log(res)
  console.log(res.keys())
  console.log(JSON.stringify(res.get(reference.rfc3339())))
  expect(res.get(reference.rfc3339())).toHaveLength(3)
})
