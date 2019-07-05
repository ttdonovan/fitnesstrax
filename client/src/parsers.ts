import { Option, Result, sequenceResult } from "ld-ambiguity"
import _ from "lodash/fp"
import { Duration } from "luxon"

export const parseNumber = (str: string): Result<Option<number>, string> => {
  if (str === "") return Result.Ok(Option.None())
  const pattern = /^[0-9]+(.[0-9]+)?$/

  if (pattern.test(str)) {
    const res = Option.fromNaN(parseFloat(str))
    if (res.isSome()) {
      return Result.Ok(res)
    } else {
      return Result.Err("parse failed")
    }
  } else {
    return Result.Err("parse failed")
  }
}

export const parseTime = (
  str: string,
): Result<
  Option<{ hours: number; minutes: number; seconds: number }>,
  string
> => {
  if (str === "") return Result.Ok(Option.None())

  const lst: Result<Array<Option<number>>, string> = sequenceResult(
    _.map(
      (v: string): Result<Option<number>, string> =>
        parseNumber(v).andThen(
          v => (v.isSome() ? Result.Ok(v) : Result.Err("invalid time string")),
        ),
    )(str.split(":")),
  )
  if (lst.isOk()) {
    const lst_ = lst.unwrap()
    if (lst_.length === 2) {
      return Result.Ok(
        Option.Some({
          hours: lst_[0].unwrap(),
          minutes: lst_[1].unwrap(),
          seconds: 0,
        }),
      )
    } else if (lst_.length === 3) {
      return Result.Ok(
        Option.Some({
          hours: lst_[0].unwrap(),
          minutes: lst_[1].unwrap(),
          seconds: lst_[2].unwrap(),
        }),
      )
    }
    return Result.Ok(Option.None())
  } else {
    return Result.Err("invalid time string")
  }
}

export const parseDuration = (
  str: string,
): Result<Option<Duration>, string> => {
  if (str === "") return Result.Ok(Option.None())
  const lst: Result<Array<Option<number>>, string> = sequenceResult(
    _.map(
      (v: string): Result<Option<number>, string> =>
        parseNumber(v).andThen(
          v =>
            v.isSome() ? Result.Ok(v) : Result.Err("invalid duration string"),
        ),
    )(str.split(":")),
  )

  if (lst.isOk()) {
    const lst_ = lst.unwrap()
    if (lst_.length === 1) {
      return Result.Ok(
        Option.Some(Duration.fromObject({ seconds: lst_[0].unwrap() })),
      )
    } else if (lst_.length === 2) {
      return Result.Ok(
        Option.Some(
          Duration.fromObject({
            minutes: lst_[0].unwrap(),
            seconds: lst_[1].unwrap(),
          }),
        ),
      )
    } else if (lst_.length === 3) {
      return Result.Ok(
        Option.Some(
          Duration.fromObject({
            hours: lst_[0].unwrap(),
            minutes: lst_[1].unwrap(),
            seconds: lst_[2].unwrap(),
          }),
        ),
      )
    } else {
      return Result.Err("invalid duration string")
    }
  } else {
    return Result.Err("invalid duration string")
  }
}

/*
export const parseDateTimeTz = (inp: string): Result<Option<DateTimeTz>, string> => {
  if (inp === "") return Result.Ok(Option.None())
  const res = parseTime(inp).map(
                t =>
                  new DateTimeTz(
                    DateTime.fromObject({
                      year: date.year,
                      month: date.month,
                      day: date.day,
                      hour: t.hours,
                      minute: t.minutes,
                      second: t.seconds,
                      zone: prefs.timezone,
                    }),
                  ),
              )
  if (res.isSome()) {
  }
  return Result.Err("
}
   */
