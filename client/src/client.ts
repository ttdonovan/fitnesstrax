import math from "mathjs"
import moment from "moment"
import _ from "lodash/fp"

import {
  encodeFormBody,
  equalDurations,
  first,
  firstFn,
  indexList,
  isSomething,
  maybe,
  midnight,
  nub,
  parseDate_,
  toRfc3339,
  parseTimestamp,
} from "./common"

import {
  Option,
  Result,
  //HistoryData,
  //HistoryEntry,
  TimeDistanceRecord,
  WeightRecord,
  timeDistanceActivityFromString,
} from "./types"

// TODO: return a WeightRecord object, not a simple dictionary
export const weightSample = (uuid, date, weight): WeightRecord =>
  new WeightRecord(uuid, date, weight)

const weightSampleFromJS = js => {
  // "weight":[{"data":{"weight":84.4,"date":"2017-05-28T05:00:00Z"},"id":"9e4e462b-494d-4784-a380-9e32218e28c7"},84.4]
  return new WeightRecord(
    js.id,
    parseDate_(js.data.date, "YYYY-MM-DDTHH:mm:ssZ"),
    math.unit(js.data.weight, "kg"),
  )
}

export const timeDistanceSample = (
  uuid,
  timestamp,
  activity,
  distance,
  duration,
): TimeDistanceRecord =>
  new TimeDistanceRecord(uuid, timestamp, activity, distance, duration)

const timeDistanceSampleFromJS = js => {
  console.log(js)
  return new TimeDistanceRecord(
    js.id,
    parseDate_(js.data.date, "YYYY-MM-DDTHH:mm:ssZ"),
    js.data.activity,
    Option.Some(math.unit(js.data.distance, "m")),
    Option.Some(moment.duration(js.data.duration, "s")),
  )
}

//                                           , 'distance': math.unit(js.data.distance, 'm')
//                                           , 'date': js.data.date
//                                           , 'activity': js.data.activity
//                                           , 'duration': js.data.duration

const recordsFromJS = (
  json: any,
): {
  weight: Array<WeightRecord>
  timeDistance: Array<TimeDistanceRecord>
} => ({
  weight: json.weight.map(j => weightSampleFromJS(j)),
  timeDistance: json.timeDistance.map(j => timeDistanceSampleFromJS(j)),
})

/*
export const historyFromRecords = (offset, records) => {
  var weightBuckets: object = indexList(
    w => w.date.format("YYYY-MM-DD"),
    records.weight,
  )
  var timeDistanceBuckets: object = indexList(
    td => td.date.format("YYYY-MM-DD"),
    records.timeDistance,
  )

  var keys: Array<string> = nub([
    ...Object.keys(weightBuckets),
    ...Object.keys(timeDistanceBuckets),
  ])
  var history = new HistoryData(
    keys.map(
      date =>
        new HistoryEntry(
          parseDate_(date, "YYYY-MM-DD"),
          first(weightBuckets[date]),
          timeDistanceBuckets[date] ? timeDistanceBuckets[date] : [],
          null,
        ),
    ),
  )
  return history
}

     */

export const saveWeight = async (
  appUrl,
  auth,
  weightSample,
): Promise<Result<WeightRecord, string>> => {
  const body = {
    date: weightSample.date.format(rfc3339Format),
    weight: weightSample.weight.toNumeric("kg"),
  }
  const url = isSomething(weightSample.uuid)
    ? "/api/weight/" + weightSample.uuid
    : "/api/weight"
  const params: RequestInit = {
    method: isSomething(weightSample.uuid) ? "PUT" : "POST",
    mode: "cors",
    headers: new Headers({
      Authorization: auth,
      "Content-Type": "application/x-www-form-urlencoded",
    }),
    body: encodeFormBody(body),
  }
  const response = await fetch(appUrl + url, params)
  const js = await response.json()
  return Result.Ok(weightSampleFromJS(js))
}

export const fetchWeight = async (
  appUrl: string,
  auth: string,
  startDate: moment.Moment,
  endDate: moment.Moment,
): Promise<Result<Array<WeightRecord>, string>> => {
  const response = await fetch(
    `${appUrl}/api/weight/history/${startDate.format()}/${endDate.format()}`,
    {
      method: "GET",
      mode: "cors",
      headers: new Headers({ Authorization: auth }),
    },
  )
  const js = await response.json()
  return Result.Ok(js.map(weightSampleFromJS))
}

export const saveTimeDistance = (
  appUrl,
  auth,
  timeDistanceSample,
): Promise<Result<TimeDistanceRecord, string>> => {
  throw new Error("not implemented")
  /*
  const body = Object.assign({
    activity: timeDistanceSample.activity,
    date: timeDistanceSample.date.format(rfc3339Format),
    distance: timeDistanceSample.distance.toNumeric("km"),
    duration: timeDistanceSample.duration.asSeconds(),
  })

  const params: RequestInit = {
    method: isSomething(timeDistanceSample.uuid) ? "PUT" : "POST",
    mode: "cors",
    headers: new Headers({
      Authorization: auth,
      "Content-Type": "application/x-www-form-urlencoded",
    }),
    body: encodeFormBody(body),
  }
  return fetch(
    appUrl +
      "/api/time-distance" +
      (isSomething(timeDistanceSample.uuid)
        ? "/" + timeDistanceSample.uuid
        : ""),
    params,
  )
    .then(response => response.json())
    .then(js => Result.Ok(timeDistanceSampleFromJS(js)))
    .catch(err => Result.Err(err))
   */
}

interface WeightJS {
  id: string
  data: {
    Weight: {
      date: string
      weight: number
    }
  }
}

interface TimeDistanceJS {
  id: string
  data: {
    TimeDistance: {
      activity: string
      comments: string | null
      date: string
      distance: number | null
      duration: number | null
    }
  }
}

type RecordJS = TimeDistanceJS | WeightJS

const isWeightJS = (val: RecordJS): val is WeightJS =>
  (<WeightJS>val).data.Weight !== undefined

const isTimeDistanceJS = (val: RecordJS): val is TimeDistanceJS =>
  (<TimeDistanceJS>val).data.TimeDistance !== undefined

const parseRecord = (
  js: TimeDistanceJS | WeightJS,
): TimeDistanceRecord | WeightRecord => {
  if (isWeightJS(js)) {
    return new WeightRecord(
      js.id,
      parseTimestamp(js.data.Weight.date).unwrap(),
      math.unit(js.data.Weight.weight, "kg"),
    )
  } else if (isTimeDistanceJS(js)) {
    return new TimeDistanceRecord(
      js.id,
      parseTimestamp(js.data.TimeDistance.date).unwrap(),
      timeDistanceActivityFromString(js.data.TimeDistance.activity).unwrap(),
      js.data.TimeDistance.distance
        ? Option.Some(math.unit(js.data.TimeDistance.distance, "m"))
        : Option.None(),
      js.data.TimeDistance.duration
        ? Option.Some(
            moment.duration({ seconds: js.data.TimeDistance.duration }),
          )
        : Option.None(),
    )
  } else {
    throw new Error("Unhandled response")
  }
}

export const fetchHistory = (
  appUrl: string,
  auth: string,
  startDate: moment.Moment,
  endDate: moment.Moment,
): Promise<Array<WeightRecord | TimeDistanceRecord>> => {
  return fetch(
    `${appUrl}/api/history/all/${toRfc3339(startDate)}/${toRfc3339(endDate)}`,
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
    .then(js => {
      return _.map(parseRecord)(js)
    })
}

const rfc3339Format: string = "YYYY-MM-DDTHH:mm:ssZ"
