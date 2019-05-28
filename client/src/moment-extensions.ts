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
  return `${this.utc().format("YYYY-MM-DDThh:mm:ss")}Z`
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
