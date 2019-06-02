import moment from "moment-timezone"
//import { midnight } from "./moment-extensions"

import { keyBy } from "./common"

import trace from "./trace"

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

describe("midnight", () => {
  it("works with UTC times", () => {
    const base = moment("2019-06-02T04:13:00Z")
    expect(base.format("YYYY-MM-DD")).toEqual("2019-06-02")
  })

  it("works with reference to the stated time zone", () => {
    const base = moment("2019-06-02T04:13:00-0600")
    console.log(
      "reference time",
      moment("2019-06-02T04:13:00-0600").format("YYYY-MM-DD"),
    )
    console.log(
      "start of day",
      moment("2019-06-02T04:13:00-0600").format("YYYY-MM-DD"),
    )
    expect(base.format("YYYY-MM-DD")).toEqual("2019-06-02")
  })
})

// VERY IMPORTANT: keying by moment.Moment does not work. I assume it is
// because moment.Moment does not implement any standard equality operator.
const bucketByDay = (
  recs: Array<moment.Moment>,
): Map<string, Array<moment.Moment>> =>
  keyBy(
    (r: moment.Moment): string =>
      trace<string>("indexing: ")(r.format("YYYY-MM-DD")),
  )(recs)

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
  expect(res.get(reference.format("YYYY-MM-DD"))).toHaveLength(3)
})
