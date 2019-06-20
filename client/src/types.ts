import { Duration } from "luxon"
import math from "mathjs"

import * as msgs from "./translations"
import DateTimeTz from "./datetimetz"
import Option from "./option"
import Result from "./result"

export type Range = { start: DateTimeTz; end: DateTimeTz }

export type Record = TimeDistanceRecord | WeightRecord

export const recordIsTimeDistance = (rec: Record): rec is TimeDistanceRecord =>
  (<TimeDistanceRecord>rec).distance !== undefined
export const recordIsWeight = (rec: Record): rec is WeightRecord =>
  (<WeightRecord>rec).weight !== undefined

export class WeightRecord {
  constructor(
    readonly id: string,
    readonly date: DateTimeTz,
    readonly weight: math.Unit,
  ) {}

  clone() {
    return new WeightRecord(this.id, this.date, this.weight.clone())
  }
}

export class TimeDistanceActivity {
  constructor(readonly repr: msgs.Message) {}
}

export const Cycling = new TimeDistanceActivity(msgs.Cycling)
export const Running = new TimeDistanceActivity(msgs.Running)

/*
export enum TimeDistanceActivity {
  Cycling,
  Running,
}
   */

export const timeDistanceActivityFromString = (
  str: string,
): Result<TimeDistanceActivity, string> => {
  if (str === "Cycling") {
    return Result.Ok(Cycling)
  } else if (str === "Running") {
    return Result.Ok(Running)
  } else {
    return Result.Err("unrecognized activity type")
  }
}

/*
export const timeDistanceActivityToString = (
  activity: TimeDistanceActivity,
): string => {
  if (activity === TimeDistanceActivity.Cycling) return "Cycling"
  else if (activity === TimeDistanceActivity.Running) return "Running"
  else throw Error("Invalid enumeration value")
}
   */

export class TimeDistanceRecord {
  constructor(
    readonly id: string,
    readonly date: DateTimeTz,
    readonly activity: TimeDistanceActivity,
    readonly distance: Option<math.Unit>,
    readonly duration: Option<Duration>,
  ) {}

  equals(other: TimeDistanceRecord) {
    return (
      this.id === other.id &&
      this.activity === other.activity &&
      this.date.equals(other.date) &&
      this.distance.equals(other.distance) &&
      this.duration.equals(other.duration)
    )
  }

  clone() {
    return new TimeDistanceRecord(
      this.id,
      this.date,
      this.activity,
      this.distance.map(v => v.clone()),
      this.duration,
    )
  }
}

/*
export class HistoryEntry {
  date: moment.Moment
  weight: WeightSample | null
  timeDistance: Array<TimeDistanceSample> | null
  setRep: Array<any> | null

  constructor({ date, weight, timeDistance, setRep }) {
    this.date = date
    this.weight = weight
    this.timeDistance = timeDistance
    this.setRep = setRep
  }

  isEmpty() {
    return (
      !isSomething(this.weight) &&
      this.timeDistance.length == 0 &&
      this.setRep.length == 0
    )
  }
}

export class HistoryData {
  entries_: Array<HistoryEntry>

  constructor(entries) {
    this.entries_ = entries
    this.entries_.sort(
      (lside, rside) =>
        lside.date < rside.date ? -1 : lside.date > rside.date ? 1 : 0,
    )
  }

  weights() {
    return this.entries_.map(e => e.weight)
  }
  timeDistanceWorkouts() {
    return [].concat.apply([], this.entries_.map(e => e.timeDistance))
  }
  setRepWorkouts() {
    return [].concat.apply([], this.entries_.map(e => e["set-rep"]))
  }

  entries() {
    return this.entries_
  }

  entry(date) {
    return firstFn(e => e.date.isSame(date))(this.entries_)
  }

  startRange() {
    return first(this.entries_.slice().reverse()).date
  }
  endRange() {
    return first(this.entries_).date
  }
}
   */
