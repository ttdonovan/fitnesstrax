import { Date, DateTimeTz } from "./datetimetz"
import { keyBy } from "./common"

describe("DateTimeTz", () => {
  it("can parse a normal UTC timestamp", () => {
    const dtz = DateTimeTz.fromString("2019-05-15T12:00:00Z").unwrap()
    expect(dtz.toString()).toEqual("2019-05-15T12:00:00Z")
  })

  it("can parse a timestamp with only an offset", () => {
    const dtz = DateTimeTz.fromString("2019-05-15T12:00:00-06:00").unwrap()
    expect(dtz.toString()).toEqual("2019-05-15T18:00:00Z")
  })

  it("can parse a timestamp with a Z and a timezone", () => {
    const dtz = DateTimeTz.fromString(
      "2019-06-15T19:00:00Z America/Phoenix",
    ).unwrap()
    expect(dtz.toString()).toEqual("2019-06-15T19:00:00Z America/Phoenix")
  })
})

describe("Verify date bounds", () => {
  it("can determine that noon UTC is within a day", () => {
    const day = new Date(2019, 1, 1)
    expect(
      DateTimeTz.fromString("2019-01-01T12:00:00Z")
        .unwrap()
        .toHaveDate(day),
    ).toBe(true)

    expect(
      DateTimeTz.fromString("2019-01-02T12:00:00Z")
        .unwrap()
        .toHaveDate(day),
    ).toBe(false)

    expect(
      DateTimeTz.fromString("2018-12-31T12:00:00Z")
        .unwrap()
        .toHaveDate(day),
    ).toBe(false)
  })

  it("can determine that midnight UTC is within a day", () => {
    const day = new Date(2019, 1, 1)

    expect(
      DateTimeTz.fromString("2019-01-01T00:00:00Z")
        .unwrap()
        .toHaveDate(day),
    ).toBe(true)

    expect(
      DateTimeTz.fromString("2019-01-02T00:00:00Z")
        .unwrap()
        .toHaveDate(day),
    ).toBe(false)

    expect(
      DateTimeTz.fromString("2018-12-31T00:00:00Z")
        .unwrap()
        .toHaveDate(day),
    ).toBe(false)
  })

  it("can determine that a time is within a day, corrected by timezone", () => {
    const day = new Date(2019, 1, 1)

    expect(
      DateTimeTz.fromString("2019-01-01T05:00:00+0500")
        .unwrap()
        .toHaveDate(day),
    ).toBe(true)

    expect(
      DateTimeTz.fromString("2019-01-01T20:00:00-0400")
        .unwrap()
        .toHaveDate(day),
    ).toBe(false)

    expect(
      DateTimeTz.fromString("2019-01-01T00:00:00Z America/New_York")
        .unwrap()
        .toHaveDate(day),
    ).toBe(false)
  })

  it("can compare a date against the specified time zone", () => {
    const day = new Date(2019, 1, 2)

    expect(
      DateTimeTz.fromString("2019-01-02T04:59:59Z America/New_York")
        .unwrap()
        .toHaveDate(day),
    ).toBe(false)
    expect(
      DateTimeTz.fromString("2019-01-02T05:00:00Z America/New_York")
        .unwrap()
        .toHaveDate(day),
    ).toBe(true)
  })

  it("compares some real dates", () => {
    const day = new Date(2017, 10, 28)

    expect(
      DateTimeTz.fromString("2017-10-28T11:25:00-0500")
        .unwrap()
        .toHaveDate(day),
    ).toBe(true)
    expect(
      DateTimeTz.fromString("2017-10-28T02:27:00-0500")
        .unwrap()
        .toHaveDate(day),
    ).toBe(true)
    expect(
      DateTimeTz.fromString("2017-10-28T05:22:00-0500")
        .unwrap()
        .toHaveDate(day),
    ).toBe(true)

    expect(
      DateTimeTz.fromString("2017-10-28T16:25:00Z America/Chicago")
        .unwrap()
        .toHaveDate(day),
    ).toBe(true)
    expect(
      DateTimeTz.fromString("2017-10-28T07:27:00Z America/Chicago")
        .unwrap()
        .toHaveDate(day),
    ).toBe(true)
    expect(
      DateTimeTz.fromString("2017-10-28T10:22:00Z America/Chicago")
        .unwrap()
        .toHaveDate(day),
    ).toBe(true)
  })
})

// VERY IMPORTANT: keying by moment.Moment does not work. I assume it is
// because moment.Moment does not implement any standard equality operator.
const bucketByDay = (recs: Array<DateTimeTz>): Map<string, Array<DateTimeTz>> =>
  keyBy((r: DateTimeTz): string => r.toFormat("yyyy-MM-dd"))(recs)

describe("bucketByDay", () => {
  const day = new Date(2017, 10, 28)

  const lst: Array<DateTimeTz> = [
    DateTimeTz.fromString("2017-10-28T11:25:00-0500").unwrap(),
    DateTimeTz.fromString("2017-10-28T02:27:00-0500").unwrap(),
    DateTimeTz.fromString("2017-10-28T05:22:00-0500").unwrap(),
  ]

  const res = bucketByDay(lst)
  expect(res.get(day.toString())).toHaveLength(3)
})
