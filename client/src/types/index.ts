import { Option, Result } from "ld-ambiguity"
import { Duration } from "luxon"
import math from "mathjs"

import * as i18n from "../i18n"
import { DateTimeTz } from "../datetimetz"
export * from "./range"

export class WeightRecord {
  constructor(readonly date: DateTimeTz, readonly weight: math.Unit) {}

  clone() {
    return new WeightRecord(this.date, this.weight.clone())
  }

  withWeight(weight: math.Unit) {
    return new WeightRecord(this.date, weight)
  }
}

export class TimeDistanceActivity {
  constructor(readonly repr: i18n.Message) {}
}

export const Cycling = new TimeDistanceActivity(i18n.Cycling)
export const Running = new TimeDistanceActivity(i18n.Running)
export const Walking = new TimeDistanceActivity(i18n.Walking)

export const timeDistanceActivityFromString = (
  str: string,
): Result<TimeDistanceActivity, string> => {
  if (str === "Cycling") {
    return Result.Ok(Cycling)
  } else if (str === "Running") {
    return Result.Ok(Running)
  } else if (str === "Walking") {
    return Result.Ok(Walking)
  } else {
    return Result.Err("unrecognized activity type")
  }
}

export class TimeDistanceRecord {
  constructor(
    readonly date: DateTimeTz,
    readonly activity: TimeDistanceActivity,
    readonly distance: Option<math.Unit>,
    readonly duration: Option<Duration>,
    readonly comments: Option<string>,
  ) {}

  equals(other: TimeDistanceRecord) {
    return (
      this.activity === other.activity &&
      this.date.equals(other.date) &&
      this.distance.equals(other.distance) &&
      this.duration.equals(other.duration) &&
      this.comments === other.comments
    )
  }

  clone() {
    return new TimeDistanceRecord(
      this.date,
      this.activity,
      this.distance.map(v => v.clone()),
      this.duration,
      this.comments,
    )
  }
}

export type RecordTypes = TimeDistanceRecord | WeightRecord

export const isTimeDistanceRecord = (
  rec: RecordTypes,
): rec is TimeDistanceRecord => (<TimeDistanceRecord>rec).distance !== undefined
export const isWeightRecord = (rec: RecordTypes): rec is WeightRecord =>
  (<WeightRecord>rec).weight !== undefined

export class Record<A> {
  constructor(readonly id: string, readonly data: A) {}
}

export const isRecord = (rec: any): rec is Record<any> =>
  (<Record<any>>rec).id !== undefined

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
