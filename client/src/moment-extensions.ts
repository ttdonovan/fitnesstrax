import moment from "moment-timezone"
import Equals from "./equals"

declare module "moment" {
  export interface Moment {
    equals: (_: moment.Moment) => boolean
    rfc3339: () => string
  }
}
moment.fn.equals = function(rside: moment.Moment): boolean {
  return this.isSame(rside)
}

moment.fn.rfc3339 = function(): string {
  return `${this.utc().format("YYYY-MM-DDTHH:mm:ss")}Z`
}

declare module "moment" {
  export interface Duration {
    equals: (_: moment.Duration) => boolean
  }
}
moment.duration.prototype.equals = function(rside: moment.Duration): boolean {
  return (
    this.milliseconds() == rside.milliseconds() &&
    this.days() == rside.days() &&
    this.months() == rside.months()
  )
}

/* This will always be midnight with respect to the day that the record was
 * recorded, independent of time zone. */
/*
export const midnight = (m: moment.Moment): moment.Moment =>
  m
    .hour(0)
    .minute(0)
    .second(0)
    .millisecond(0)
   */
/*
    .hour(0)
    .minute(0)
    .second(0)
    .millisecond(0)
     */

export const withinDay = (day: moment.Moment, target: moment.Moment): boolean =>
  (day.isBefore(target) || day.equals(target)) &&
  day
    .clone()
    .add(1, "day")
    .isAfter(target)
