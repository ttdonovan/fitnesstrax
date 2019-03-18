import math from "mathjs"
import moment from "moment"

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
} from "./common"

import {
  Result,
  HistoryData,
  HistoryEntry,
  TimeDistanceSample,
  WeightSample,
} from "./types"

// TODO: return a WeightSample object, not a simple dictionary
export const weightSample = (uuid, date, weight): WeightSample =>
  new WeightSample(uuid, date, weight)

const weightSampleFromJS = js => {
  // "weight":[{"data":{"weight":84.4,"date":"2017-05-28T05:00:00Z"},"id":"9e4e462b-494d-4784-a380-9e32218e28c7"},84.4]
  return new WeightSample(
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
): TimeDistanceSample =>
  new TimeDistanceSample(uuid, timestamp, activity, distance, duration)

const timeDistanceSampleFromJS = js => {
  console.log(js)
  return new TimeDistanceSample(
    js.id,
    parseDate_(js.data.date, "YYYY-MM-DDTHH:mm:ssZ"),
    js.data.activity,
    math.unit(js.data.distance, "m"),
    moment.duration(js.data.duration, "s"),
  )
}

//                                           , 'distance': math.unit(js.data.distance, 'm')
//                                           , 'date': js.data.date
//                                           , 'activity': js.data.activity
//                                           , 'duration': js.data.duration

const recordsFromJS = (
  json: any,
): {
  weight: Array<WeightSample>
  timeDistance: Array<TimeDistanceSample>
} => ({
  weight: json.weight.map(j => weightSampleFromJS(j)),
  timeDistance: json.timeDistance.map(j => timeDistanceSampleFromJS(j)),
})

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

export const fetchHistory = (
  appUrl,
  auth,
  startDate,
  endDate,
): Promise<
  Result<
    { weight: Array<WeightSample>; timeDistance: Array<TimeDistanceSample> },
    string
  >
> => {
  var params: RequestInit = {
    method: "GET",
    mode: "cors",
    headers: new Headers({ Authorization: auth }),
  }
  return (isSomething(startDate) && isSomething(endDate)
    ? fetch(
        appUrl +
          "/api/history/date/" +
          startDate.format() +
          "/" +
          endDate.format(),
        params,
      )
    : fetch(appUrl + "/api/history", params)
  )
    .then(response => response.json())
    .then(js => Result.Ok(recordsFromJS(js)))
}

export const saveWeight = async (
  appUrl,
  auth,
  weightSample,
): Promise<Result<WeightSample, string>> => {
  const body = {
    date: weightSample.date.format(standardTimeFormat),
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

export const saveTimeDistance = (
  appUrl,
  auth,
  timeDistanceSample,
): Promise<Result<TimeDistanceSample, string>> => {
  const body = Object.assign({
    activity: timeDistanceSample.activity,
    date: timeDistanceSample.date.format(standardTimeFormat),
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
}

const standardTimeFormat = "YYYY-MM-DDTHH:mm:ssZ"
