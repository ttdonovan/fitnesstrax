import { Duration } from "luxon"
import math from "mathjs"
import _ from "lodash/fp"

import { DateTimeTz } from "./datetimetz"

import { Option, Result, sequenceResult } from "ld-ambiguity"

import {
  Record,
  RecordTypes,
  StepRecord,
  TimeDistanceRecord,
  WeightRecord,
  timeDistanceActivityFromString,
  isRecord,
  isStepRecord,
  isTimeDistanceRecord,
  isWeightRecord,
} from "./types"

interface StepJS {
  Steps: {
    date: string
    steps: number
  }
}

const toStepJS = (record: StepRecord): StepJS => ({
  Steps: {
    date: record.date.toString(),
    steps: record.steps,
  },
})

const toStepRecord = (js: StepJS): Result<StepRecord, string> => {
  const date = DateTimeTz.fromString(js.Steps.date)
  if (!date.isOk()) return Result.Err(date.unwrapErr())

  return Result.Ok(new StepRecord(date.unwrap(), js.Steps.steps))
}

interface WeightJS {
  Weight: {
    date: string
    weight: number
  }
}

const toWeightJS = (record: WeightRecord): WeightJS => ({
  Weight: {
    date: record.date.toString(),
    weight: record.weight.toNumber("kg"),
  },
})

const toWeightRecord = (js: WeightJS): Result<WeightRecord, string> => {
  const date = DateTimeTz.fromString(js.Weight.date)
  if (!date.isOk()) return Result.Err(date.unwrapErr())

  const val = math.unit(js.Weight.weight, "kg")

  return Result.Ok(new WeightRecord(date.unwrap(), val))
}

interface TimeDistanceJS {
  TimeDistance: {
    activity: string
    comments: string | null
    date: string
    distance: number | null
    duration: number | null
  }
}

const toTimeDistanceJS = (record: TimeDistanceRecord): TimeDistanceJS => ({
  TimeDistance: {
    activity: record.activity.repr.en,
    comments: record.comments.unwrap_(),
    date: record.date.toString(),
    distance: record.distance.map(d => d.toNumber("m")).unwrap_(),
    duration: record.duration.map(d => d.as("second")).unwrap_(),
  },
})

type RecordJSTypes = StepJS | TimeDistanceJS | WeightJS

const isStepJS = (val: RecordJSTypes): val is StepJS =>
  (<StepJS>val).Steps !== undefined

const isWeightJS = (val: RecordJSTypes): val is WeightJS =>
  (<WeightJS>val).Weight !== undefined

const isTimeDistanceJS = (val: RecordJSTypes): val is TimeDistanceJS =>
  (<TimeDistanceJS>val).TimeDistance !== undefined

interface RecordJS {
  id: string
  data: RecordJSTypes
}

const toRecordJS = (record: Record<RecordTypes>): RecordJS => {
  const data = record.data
  let dataJS = null

  if (isStepRecord(data)) {
    dataJS = toStepJS(data)
  } else if (isTimeDistanceRecord(data)) {
    dataJS = toTimeDistanceJS(data)
  } else if (isWeightRecord(data)) {
    dataJS = toWeightJS(data)
  } else {
    throw new Error("unrecognized record data type")
  }

  return {
    id: record.id,
    data: dataJS,
  }
}

const parseRecord = (js: any): Result<Record<RecordTypes>, string> => {
  if ((<RecordJS>js).id === undefined)
    return Result.Err("invalid record: no ID available")
  if ((<RecordJS>js).data === undefined)
    return Result.Err("invalid record: no data field available")

  //console.log(JSON.stringify(js.data))
  if (isStepJS(js.data)) {
    return toStepRecord(js.data).map((r: StepRecord) => new Record(js.id, r))
  } else if (isWeightJS(js.data)) {
    return toWeightRecord(js.data).map(
      (r: WeightRecord) => new Record(js.id, r),
    )
  } else if (js.data.TimeDistance) {
    const date = DateTimeTz.fromString(js.data.TimeDistance.date)
    if (!date.isOk()) return Result.Err(date.unwrapErr())

    const activity = timeDistanceActivityFromString(
      js.data.TimeDistance.activity,
    )
    if (!activity.isOk()) return Result.Err(activity.unwrapErr())

    const distance: Result<Option<math.Unit>, string> = js.data.TimeDistance
      .distance
      ? Result.try<Option<math.Unit>, Error>(() =>
          Option.Some(math.unit(js.data.TimeDistance.distance, "m")),
        ).mapErr(err => err.toString())
      : Result.Ok(Option.None())
    if (!distance.isOk()) return Result.Err(distance.unwrapErr())

    const duration: Result<Option<Duration>, string> = js.data.TimeDistance
      .duration
      ? Result.try<Option<Duration>, Error>(() =>
          Option.Some(
            Duration.fromObject({ seconds: js.data.TimeDistance.duration }),
          ),
        ).mapErr(err => err.toString())
      : Result.Ok(Option.None())
    if (!duration.isOk()) return Result.Err(duration.unwrapErr())

    return Result.Ok(
      new Record(
        js.id,
        new TimeDistanceRecord(
          date.unwrap(),
          activity.unwrap(),
          distance.unwrap(),
          duration.unwrap(),
          new Option<string>(js.data.TimeDistance.comments),
        ),
      ),
    )
  } else {
    throw new Error(`Unhandled response: ${JSON.stringify(js)}`)
  }
}

class Client {
  appUrl: string

  constructor(appUrl: string) {
    this.appUrl = appUrl
  }

  fetchHistory = (
    auth: string,
    startDate: DateTimeTz,
    endDate: DateTimeTz,
  ): Promise<Result<Array<Record<RecordTypes>>, string>> => {
    return fetch(
      `${this.appUrl}/api/history/all/${encodeURIComponent(
        startDate.toRFC3339(),
      )}/${encodeURIComponent(endDate.toRFC3339())}`,
      {
        method: "GET",
        mode: "cors",
        headers: new Headers({
          accept: "application/json",
          authorization: `Bearer ${auth}`,
        }),
      },
    )
      .then(r => r.json())
      .then(
        (js: Array<any>): Result<Array<Record<RecordTypes>>, string> =>
          sequenceResult(_.map(parseRecord)(js)),
      )
  }

  rfc3339Format: string = "YYYY-MM-DDTHH:mm:ssZ"

  authenticate = (auth: string): Promise<boolean> => {
    return fetch(`${this.appUrl}/api/history/all`, {
      method: "OPTIONS",
      mode: "cors",
      headers: new Headers({
        authorization: `Bearer ${auth}`,
      }),
    }).then(r => r.ok)
  }

  saveRecord = (
    auth: string,
    record: Record<RecordTypes> | RecordTypes,
  ): Promise<Result<Record<RecordTypes>, string>> => {
    const commonOptions = {
      headers: new Headers({
        Accept: "application/json",
        "Content-Type": "application/json",
        Authorization: `Bearer ${auth}`,
      }),
    }

    if (isRecord(record)) {
      let data = null
      if (isStepRecord(record.data)) {
        data = toStepJS(record.data)
      } else if (isWeightRecord(record.data)) {
        data = toWeightJS(record.data)
      } else if (isTimeDistanceRecord(record.data)) {
        data = toTimeDistanceJS(record.data)
      } else {
        throw new Error("unhandled record type")
      }

      return fetch(`${this.appUrl}/api/record/${record.id}`, {
        ...commonOptions,
        mode: "cors",
        method: "POST",
        body: JSON.stringify(data),
      })
        .then(r => r.json())
        .then(js => Result.Ok(record))
        .catch(err => Result.Err(err.toString()))
    } else {
      let url = ""
      let js = ""

      if (isStepRecord(record)) {
        url = `${this.appUrl}/api/record/steps`
        js = JSON.stringify(toStepJS(record).Steps)
      } else if (isTimeDistanceRecord(record)) {
        url = `${this.appUrl}/api/record/timedistance`
        js = JSON.stringify(toTimeDistanceJS(record).TimeDistance)
      } else if (isWeightRecord(record)) {
        url = `${this.appUrl}/api/record/weight`
        js = JSON.stringify(toWeightJS(record).Weight)
      }

      return fetch(url, {
        ...commonOptions,
        mode: "cors",
        method: "PUT",
        body: js,
      })
        .then(r => r.json())
        .then(uuid => Result.Ok(new Record(uuid, record)))
        .catch(err => Result.Err(err.toString()))
    }

    throw new Error("unhandled record type")
  }
}

export default Client
