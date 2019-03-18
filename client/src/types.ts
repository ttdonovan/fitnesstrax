import * as moment from "moment"
import math from "mathjs"

import { equalDurations, first, firstFn, isSomething } from "./common"

export class Result<A, E> {
  ok_: A | null
  err_: E | null

  constructor(ok: A | null, err: E | null) {
    if (ok && !err) {
      this.ok_ = ok
      this.err_ = null
    } else if (!ok && err) {
      this.ok_ = null
      this.err_ = err
    } else {
      throw new Error("cannot create a Result with both ok and err values")
    }
  }

  static Ok<A>(val: A): Result<A, any> {
    return new Result(val, null)
  }

  static Err<E>(err: E): Result<any, E> {
    return new Result(null, err)
  }

  map<B>(f: (A) => B): Result<B, E> {
    if (this.ok_) {
      return Result.Ok(f(this.ok_))
    }
    return Result.Err(this.err_)
  }

  map_err<F>(f: (E) => F): Result<A, F> {
    if (this.err_) {
      return Result.Err(f(this.err_))
    }
    return Result.Ok(this.ok_)
  }

  unwrap(): A | null {
    return this.ok_
  }
}

export class WeightSample {
  uuid: string
  date: moment.Moment
  weight: math.Unit

  constructor(uuid, date, weight) {
    ;[this.uuid, this.date, this.weight] = [uuid, date, weight]
  }

  clone() {
    return new WeightSample(this.uuid, this.date.clone(), this.weight.clone())
  }
}

export enum TimeDistanceActivity {
  Cycling,
  Running,
}

export class TimeDistanceSample {
  uuid: string
  date: moment.Moment
  activity: TimeDistanceActivity
  distance: math.Unit
  duration: moment.Duration

  constructor(uuid, timestamp, activity, distance, duration) {
    ;[this.uuid, this.date, this.activity, this.distance, this.duration] = [
      uuid,
      timestamp,
      activity,
      distance,
      duration,
    ]
  }

  equals(other) {
    return (
      this.uuid == other.uuid &&
      this.activity == other.activity &&
      this.date.isSame(other.date) &&
      this.distance.equals(other.distance) &&
      equalDurations(this.duration, other)
    )
  }

  clone() {
    return new TimeDistanceSample(
      this.uuid,
      this.date.clone(),
      this.activity,
      this.distance.clone(),
      moment.duration(this.duration),
    )
  }
}

export class HistoryEntry {
  date: moment.Moment
  weight: WeightSample | null
  timeDistance: Array<TimeDistanceSample> | null
  setRep: Array<any> | null

  constructor(date, weight, timeDistance, setRep) {
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
