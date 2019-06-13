import moment from "moment-timezone"
import Equals from "./equals"

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
