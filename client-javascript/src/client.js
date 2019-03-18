import math from 'mathjs'
import moment from 'moment'

import { encodeFormBody, equalDurations, first, firstFn, indexList, isSomething, maybe, midnight, nub, parseDate_ } from './common'

export class WeightSample {
    constructor (uuid, date, weight, avgWeight) {
        [this.uuid, this.date, this.weight] =
            [uuid, date, weight]
    }

    clone () {
        return new WeightSample(this.uuid, this.date.clone(), this.weight.clone())
    }
}

// TODO: return a WeightSample object, not a simple dictionary
export const weightSample = (uuid, date, weight) =>
    ({ uuid: uuid, date: date, weight: weight })

const weightSampleFromJS = (js) => {
        // "weight":[{"data":{"weight":84.4,"date":"2017-05-28T05:00:00Z"},"id":"9e4e462b-494d-4784-a380-9e32218e28c7"},84.4]
        return new WeightSample(js.id, parseDate_(js.data.date, 'YYYY-MM-DDTHH:mm:ssZ'), math.unit(js.data.weight, 'kg'))
    }


export class TimeDistanceSample {
    constructor (uuid, timestamp, activity, distance, duration) {
        [this.uuid, this.date, this.activity, this.distance, this.duration] =
            [uuid, timestamp, activity, distance, duration]
    }

    equals (other) {
        return this.uuid == other.uuid
            && this.activity == other.activity
            && this.date.isSame(other.date)
            && this.distance.equals(other.distance)
            && equalDurations(this.duration, other)
    }

    clone () {
        return new TimeDistanceSample(this.uuid, this.date.clone(), this.activity, this.distance.clone(), moment.duration(this.duration))
    }
}


export const timeDistanceSample = (uuid, timestamp, activity, distance, duration) =>
    new TimeDistanceSample(uuid, timestamp, activity, distance, duration)


const timeDistanceSampleFromJS = (js) => {
        console.log(js)
        return new TimeDistanceSample( js.id
                                     , parseDate_(js.data.date, 'YYYY-MM-DDTHH:mm:ssZ')
                                     , js.data.activity
                                     , math.unit(js.data.distance, 'm')
                                     , moment.duration(js.data.duration, 's')
                                     )
    }

//                                           , 'distance': math.unit(js.data.distance, 'm')
//                                           , 'date': js.data.date
//                                           , 'activity': js.data.activity
//                                           , 'duration': js.data.duration

export class HistoryEntry {
    constructor (date, weight, timeDistance, setRep) {
        this.date = date
        this.weight = weight
        this.timeDistance = timeDistance
        this.setRep = setRep
    }

    isEmpty () {
        return (! isSomething(this.weight) && this.timeDistance.length == 0 && this.setRep.length == 0)
    }
}


export class HistoryData {
    constructor (entries) {
        this.entries = entries
        this.entries.sort((h) => h.date)
    }

    weights () { return this.entries.map(e => e.weight) }
    timeDistanceWorkouts () { return [].concat.apply([], this.entries.map(e => e.timeDistance)) }
    setRepWorkouts () { return [].concat.apply([], this.entries.map(e => e['set-rep'])) }

    entries () { return this.entries }

    entry (date) { return firstFn((e) => e.date.isSame(date))(this.entries) }

    startRange () { return first(this.entries.slice().reverse()).date }
    endRange () { return first(this.entries).date }
}


const recordsFromJS = (json) => (
    { weight: json.weight.map(j => weightSampleFromJS(j))
    , timeDistance: json.timeDistance.map(j => timeDistanceSampleFromJS(j))
    }
)


export const historyFromRecords = (offset, records) => {
    var weightBuckets = indexList((w) => w.date.format('YYYY-MM-DD'), records.weight)
    var timeDistanceBuckets = indexList((td) => td.date.format('YYYY-MM-DD'), records.timeDistance)

    var keys = nub([].concat(Object.keys(weightBuckets), Object.keys(timeDistanceBuckets)))
    var history = new HistoryData(keys.map(
                        (date) => new HistoryEntry( parseDate_(date, 'YYYY-MM-DD')
                                                  , first(weightBuckets[date])
                                                  , timeDistanceBuckets[date] ? timeDistanceBuckets[date] : []
                                                  , null)))
    return history
}


export const fetchHistory = (appUrl, auth, startDate, endDate) => {
    var params = { method: 'GET'
                 , mode: 'cors'
                 , headers: new Headers({ 'Authorization': auth })
                 }
    return (isSomething(startDate) && isSomething(endDate)
                ? fetch(appUrl + '/api/history/date/' + startDate.format() + '/' + endDate.format(), params)
                : fetch(appUrl + '/api/history', params))
                .then((response) => response.json())
                .then((js) => ({value: recordsFromJS(js)}))
}


export const saveWeight = (appUrl, auth, weightSample) => {
    const body = { 'date': weightSample.date.format(standardTimeFormat)
                 , 'weight': weightSample.weight.toNumeric('kg')
                 }
    const url = isSomething(weightSample.uuid) ? '/api/weight/' + weightSample.uuid : '/api/weight'
    const params = { method: isSomething(weightSample.uuid) ? 'PUT' : 'POST'
                   , mode: 'cors'
                   , headers: new Headers({ 'Authorization': auth
                                          , 'Content-Type': 'application/x-www-form-urlencoded'
                                          })
                   , body: encodeFormBody(body)
                   }
    return fetch(appUrl + url, params)
                .then((response) => response.json())
                .then((js) => weightSampleFromJS(js))
}


export const saveTimeDistance = (appUrl, auth, timeDistanceSample) => {
    var body = Object.assign( { activity: timeDistanceSample.activity
                              , date: timeDistanceSample.date.format(standardTimeFormat)
                              , distance: timeDistanceSample.distance.toNumeric('km')
                              , duration: timeDistanceSample.duration.asSeconds()
                              }
                            )

    var params = { method: isSomething(timeDistanceSample.uuid) ? 'PUT' : 'POST'
                 , mode: 'cors'
                 , headers: new Headers({ 'Authorization': auth
                                        , 'Content-Type': 'application/x-www-form-urlencoded'
                                        })
                 , body: encodeFormBody(body)
                 }
    return fetch(appUrl + '/api/time-distance' + (isSomething(timeDistanceSample.uuid) ? '/' + timeDistanceSample.uuid : ''), params)
                .then((response) => response.json())
                .then((js) => timeDistanceSampleFromJS(js))
}


const standardTimeFormat = 'YYYY-MM-DDTHH:mm:ssZ'

