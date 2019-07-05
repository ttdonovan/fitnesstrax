import { Option, Result } from "ld-ambiguity"
import { Duration } from "luxon"

import { parseDuration, parseNumber, parseTime } from "./parsers"

describe("parseNumber", () => {
  it("accepts a valid number", () => {
    expect(parseNumber("15.5")).toEqual(Result.Ok(Option.Some(15.5)))
    expect(parseNumber("15.59")).toEqual(Result.Ok(Option.Some(15.59)))
    expect(parseNumber("16")).toEqual(Result.Ok(Option.Some(16)))
  })

  it("accepts an empty string", () =>
    expect(parseNumber("")).toEqual(Result.Ok(Option.None())))

  it("returns an error when letters are involved", () => {
    expect(parseNumber("16a")).toEqual(Result.Err("parse failed"))
    expect(parseNumber("b16a")).toEqual(Result.Err("parse failed"))
  })
})

describe("time parsing", () => {
  it("returns an Ok(None) on an empty string", () =>
    expect(parseTime("")).toEqual(Result.Ok(Option.None())))

  it("parses a valid three-section time", () =>
    expect(parseTime("15:25:15")).toEqual(
      Result.Ok(
        Option.Some({
          hours: 15,
          minutes: 25,
          seconds: 15,
        }),
      ),
    ))

  it("parses a valid two-section time", () =>
    expect(parseTime("15:25")).toEqual(
      Result.Ok(
        Option.Some({
          hours: 15,
          minutes: 25,
          seconds: 0,
        }),
      ),
    ))

  it("returns an error on an invalid time", () =>
    expect(parseTime("15:2a")).toEqual(Result.Err("invalid time string")))

  it("returns an error on a partial parse", () => {
    expect(parseTime("15:")).toEqual(Result.Err("invalid time string"))
    expect(parseTime("15:16:")).toEqual(Result.Err("invalid time string"))
  })
})

/*
describe("datetime parsing", () => {
  it("accepts an empty string", () =>
    expect(parseDateTimeTz("")).toEqual(Result.Ok(Option.None())))

  it("accepts a valid date time string", () => {})
})
   */

describe("duration parsing", () => {
  it("accepts an empty string", () =>
    expect(parseDuration("")).toEqual(Result.Ok(Option.None())))

  it("accepts a valid one-section duration", () =>
    expect(parseDuration("15")).toEqual(
      Result.Ok(Option.Some(Duration.fromObject({ seconds: 15 }))),
    ))

  it("accepts a valid two-section duration", () =>
    expect(parseDuration("15:16")).toEqual(
      Result.Ok(Option.Some(Duration.fromObject({ minutes: 15, seconds: 16 }))),
    ))

  it("accepts a valid three-section duration", () =>
    expect(parseDuration("15:16:17")).toEqual(
      Result.Ok(
        Option.Some(
          Duration.fromObject({ hours: 15, minutes: 16, seconds: 17 }),
        ),
      ),
    ))

  it("returns an error on a partial parse", () => {
    expect(parseDuration("15:")).toEqual(Result.Err("invalid duration string"))
    expect(parseDuration("15:16:")).toEqual(
      Result.Err("invalid duration string"),
    )
  })

  it("rejects an invalid duration", () => {
    expect(parseDuration("abcd")).toEqual(Result.Err("invalid duration string"))
    expect(parseDuration("15a")).toEqual(Result.Err("invalid duration string"))
    expect(parseDuration("b15a")).toEqual(Result.Err("invalid duration string"))
    expect(parseDuration("15:16a")).toEqual(
      Result.Err("invalid duration string"),
    )
    /*
    expect(parseDuration("15:165")).toEqual(
      Result.Err("invalid duration string"),
    )
    */
    expect(parseDuration("15:16:17:18")).toEqual(
      Result.Err("invalid duration string"),
    )
  })
})
