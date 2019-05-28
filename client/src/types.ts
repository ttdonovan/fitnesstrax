import * as moment from "moment"
import math from "mathjs"

import { equalDurations, first, firstFn, isSomething } from "./common"

export class Option<A> {
  val_: A | null

  constructor(val: A | null) {
    this.val_ = val
  }

  static Some<A>(val: A): Option<A> {
    return new Option(val)
  }

  static None<A>(): Option<A> {
    return new Option(null)
  }

  is_some(): boolean {
    return Boolean(this.val_)
  }

  is_none(): boolean {
    return !Boolean(this.val_)
  }

  map<B>(f: (A) => B): Option<B> {
    if (this.val_) {
      return Option.Some(f(this.val_))
    }
    return Option.None()
  }

  unwrap(): A {
    if (this.val_) {
      return this.val_
    }
    throw new Error("forced unwrap of an empty Option")
  }
}

// TODO: probably irrelevant. Figure out what Typescript provides
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

  unwrap(): A {
    if (this.ok_) {
      return this.ok_
    }
    throw new Error("forced unwrap of an empty Result")
  }
}

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
    if (
      this.id !== other.id ||
      this.activity !== other.activity ||
      this.date.isSame(other.date)
    ) {
      return false
    }
    if (
      this.distance.is_some() !== other.distance.is_some() ||
      !this.distance.unwrap().equals(other.distance.unwrap())
    ) {
      return false
    }
    if (
      this.duration.is_some() !== other.duration.is_some() ||
      !equalDurations(this.duration.unwrap(), other.duration.unwrap())
    ) {
      return false
    }
    return true
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
