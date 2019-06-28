import { Date, DateTimeTz } from "../datetimetz"

import { Range, daysInRange } from "./range"

describe("daysInRange", () => {
  it("handles a single-day range", () => {
    const range = new Range(
      DateTimeTz.fromString("2019-05-10T15:00:00Z UTC").unwrap(),
      DateTimeTz.fromString("2019-05-10T15:00:00Z UTC").unwrap(),
    )
    const days = daysInRange(range)
    expect(days).toEqual([new Date(2019, 5, 10)])
  })

  it("fills in a sub-24-hour span", () => {
    const range = new Range(
      DateTimeTz.fromString("2019-05-10T15:00:00Z UTC").unwrap(),
      DateTimeTz.fromString("2019-05-11T02:00:00Z UTC").unwrap(),
    )
    const days = daysInRange(range)
    expect(days).toEqual([new Date(2019, 5, 10), new Date(2019, 5, 11)])
  })

  it("fills in days", () => {
    const range = new Range(
      DateTimeTz.fromString("2019-05-10T15:00:00Z UTC").unwrap(),
      DateTimeTz.fromString("2019-05-18T02:00:00Z UTC").unwrap(),
    )
    const days = daysInRange(range)
    expect(days).toEqual([
      new Date(2019, 5, 10),
      new Date(2019, 5, 11),
      new Date(2019, 5, 12),
      new Date(2019, 5, 13),
      new Date(2019, 5, 14),
      new Date(2019, 5, 15),
      new Date(2019, 5, 16),
      new Date(2019, 5, 17),
      new Date(2019, 5, 18),
    ])
  })

  it("returns values based on the specified time zone", () => {
    const range = new Range(
      DateTimeTz.fromString("2019-05-10T02:00:00Z America/New_York").unwrap(),
      DateTimeTz.fromString("2019-05-11T02:00:00Z America/New_York").unwrap(),
    )
    const days = daysInRange(range)
    expect(days).toEqual([new Date(2019, 5, 9), new Date(2019, 5, 10)])
  })
})
