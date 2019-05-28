import * as moment from "moment"
import math from "mathjs"

import Option from "./option"
import Result from "./result"
//import { equalDurations } from "./common"

export class WeightRecord {
  constructor(
    readonly id: string,
    readonly date: moment.Moment,
    readonly weight: math.Unit,
  ) {}

  clone() {
    return new WeightRecord(this.id, this.date.clone(), this.weight.clone())
  }
}

export enum TimeDistanceActivity {
  Cycling,
  Running,
}

export const timeDistanceActivityFromString = (
  str: String,
): Result<TimeDistanceActivity, string> => {
  if (str === "Cycling") {
    return Result.Ok(TimeDistanceActivity.Cycling)
  } else if (str === "Running") {
    return Result.Ok(TimeDistanceActivity.Running)
  } else {
    return Result.Err("unrecognized activity type")
  }
}

export class TimeDistanceRecord {
  constructor(
    readonly id: string,
    readonly date: moment.Moment,
    readonly activity: TimeDistanceActivity,
    readonly distance: Option<math.Unit>,
    readonly duration: Option<moment.Duration>,
  ) {}

  equals(other) {
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
      this.date.clone(),
      this.activity,
      this.distance.map(v => v.clone()),
      this.duration.map(v => moment.duration(v)),
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
