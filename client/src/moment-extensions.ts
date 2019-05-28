import moment from "moment"
import Equals from "./equals"

declare module "moment" {
  export interface Moment {
    equals: (_: moment.Moment) => boolean
  }
}
moment.fn.equals = function(rside: moment.Moment): boolean {
  return this.isSame(rside)
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
