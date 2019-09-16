import { Option, Result } from "ld-ambiguity"
import { Duration } from "luxon"
import math from "mathjs"

import * as i18n from "../i18n"
import { DateTimeTz } from "../datetimetz"
export * from "./range"

export class StepRecord {
  constructor(readonly date: DateTimeTz, readonly steps: number) {}

  equals(other: StepRecord) {
    return this.date.equals(other.date) && this.steps == other.steps
  }

  clone() {
    return new StepRecord(this.date, this.steps)
  }

  withSteps(steps: number) {
    return new StepRecord(this.date, steps)
  }
}

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
  readonly isTimeDistanceActivity: boolean
  constructor(readonly repr: i18n.Message) {
    this.isTimeDistanceActivity = true
  }
}

export const Cycling = new TimeDistanceActivity(i18n.Cycling)
export const Running = new TimeDistanceActivity(i18n.Running)
export const Swimming = new TimeDistanceActivity(i18n.Swimming)
export const Walking = new TimeDistanceActivity(i18n.Walking)

export const timeDistanceActivityFromString = (
  str: string,
): Result<TimeDistanceActivity, string> => {
  if (str === "Cycling") {
    return Result.Ok(Cycling)
  } else if (str === "Running") {
    return Result.Ok(Running)
  } else if (str === "Swimming") {
    return Result.Ok(Swimming)
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

export class SetRepActivity {
  readonly isSetRepActivity: boolean
  constructor(readonly repr: i18n.Message) {
    this.isSetRepActivity = true
  }
}

export const Situps = new SetRepActivity(i18n.Situps)
export const Pushups = new SetRepActivity(i18n.Pushups)

export const setRepActivityFromString = (
  str: string,
): Result<SetRepActivity, string> => {
  if (str === "Pushups") {
    return Result.Ok(Pushups)
  } else if (str === "Situps") {
    return Result.Ok(Situps)
  } else {
    return Result.Err("unrecognized activity type")
  }
}

export class SetRepRecord {
  constructor(
    readonly date: DateTimeTz,
    readonly activity: SetRepActivity,
    readonly sets: Array<number>,
  ) {}

  equals(other: SetRepRecord) {
    return (
      this.date.equals(other.date) &&
      this.activity === other.activity &&
      this.sets === other.sets
    )
  }

  clone() {
    return new SetRepRecord(this.date, this.activity, this.sets)
  }
}

export type ActivityTypes = TimeDistanceActivity | SetRepActivity

export const isSetRepActivity = (
  activity: ActivityTypes,
): activity is SetRepActivity => (<SetRepActivity>activity).isSetRepActivity

export const isTimeDistanceActivity = (
  activity: ActivityTypes,
): activity is TimeDistanceActivity =>
  (<TimeDistanceActivity>activity).isTimeDistanceActivity

export type RecordTypes =
  | StepRecord
  | TimeDistanceRecord
  | WeightRecord
  | SetRepRecord

export const isStepRecord = (rec: RecordTypes): rec is StepRecord =>
  (<StepRecord>rec).steps !== undefined
export const isSetRepRecord = (rec: RecordTypes): rec is SetRepRecord =>
  (<SetRepRecord>rec).sets !== undefined
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
