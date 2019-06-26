import { DateTime, IANAZone } from "luxon"
import pad from "pad-left"

import Option from "./option"
import Result from "./result"

const UTC = IANAZone.create("UTC")

export class Date {
  constructor(
    readonly year: number,
    readonly month: number,
    readonly day: number,
  ) {}

  toString(): string {
    return `${this.year}-${pad(this.month, 2, "0")}-${pad(this.day, 2, "0")}`
  }

  static fromString = (s: string): Result<Date, string> => {
    const parts = s.split("-")
    if (parts.length !== 3) {
      Result.Err(`invalid date string, ${s}`)
    }
    const year = Option.fromNaN(parseInt(parts[0]))
    if (!year.isSome()) Result.Err("invalid year")
    const month = Option.fromNaN(parseInt(parts[1]))
    if (!month.isSome()) Result.Err("invalid month")
    const day = Option.fromNaN(parseInt(parts[2]))
    if (!day.isSome()) Result.Err("invalid day")

    return Result.Ok(new Date(year.unwrap(), month.unwrap(), day.unwrap()))
  }
}

export class DateTimeTz {
  constructor(readonly timestamp: DateTime) {}

  static fromDate = (date: Date, zone: IANAZone): DateTimeTz =>
    new DateTimeTz(
      DateTime.fromObject({
        year: date.year,
        month: date.month,
        day: date.day,
        hour: 0,
        minute: 0,
        second: 0,
        zone: zone,
      }),
    )

  map(fn: (_: DateTime) => DateTime): DateTimeTz {
    return new DateTimeTz(fn(this.timestamp))
  }

  equals(rside: DateTimeTz): boolean {
    return this.timestamp.equals(rside.timestamp)
  }

  toFormat(formatStr: string): string {
    return this.timestamp.toFormat(formatStr)
  }

  toHaveDate(rside: Date): boolean {
    return (
      this.timestamp.year === rside.year &&
      this.timestamp.month === rside.month &&
      this.timestamp.day === rside.day
    )
  }

  toString(): string {
    const rfc3339Format = "yyyy-MM-dd'T'HH:mm:ss"
    if (this.timestamp.zone.name === "UTC") {
      return `${this.timestamp.toFormat(rfc3339Format)}Z`
    } else {
      return `${this.timestamp.setZone("UTC").toFormat(rfc3339Format)}Z ${
        this.timestamp.zone.name
      }`
    }
  }

  static fromString(s: string): Result<DateTimeTz, string> {
    const parts = s.split(" ")
    if (parts.length === 0) return Result.Err("No data to parse")

    const dt = DateTime.fromISO(parts[0]).toUTC()
    if (!dt.isValid) {
      return Result.Err("Invalid timestamp")
    }

    if (parts.length === 2) {
      const tz = IANAZone.create(parts[1])
      if (!tz.isValid) return Result.Err("Invalid timezone")
      return Result.Ok(new DateTimeTz(dt.setZone(tz)))
    } else {
      return Result.Ok(new DateTimeTz(dt))
    }
  }
}

export default DateTimeTz
