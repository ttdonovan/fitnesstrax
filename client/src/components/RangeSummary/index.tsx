import math from "mathjs"
import React from "react"
import _ from "lodash/fp"

/*
import { first, isSomething, intercalate, sum, divmod, padStr } from "../common"
import { TimeDistanceActivity } from "../types"
import { TimeDistanceSummary } from "./TimeDistanceRow"
*/

import { first } from "../../common"
import { UserPreferences } from "../../settings"
import * as types from "../../types"

interface Props {
  dayCount: number
  prefs: UserPreferences
  records: Array<types.Record<types.RecordTypes>>
}

const RangeSummary: React.SFC<Props> = ({ prefs, records }: Props) => {
  console.log(records)
  const weights = _.filter(
    (r: types.Record<types.RecordTypes>): boolean =>
      types.isWeightRecord(r.data),
  )(records) as Array<types.Record<types.WeightRecord>>

  const startWeight = first(weights)
  const endWeight = first(weights.slice().reverse())
  const weightChange = math.subtract(
    endWeight.map(r => r.data.weight).or(math.unit(0, prefs.units.mass)),
    startWeight.map(r => r.data.weight).or(math.unit(0, prefs.units.mass)),
  ) as math.Unit

  console.log(weightChange)

  const timeDistance = _.filter(
    (r: types.Record<types.RecordTypes>): boolean =>
      types.isTimeDistanceRecord(r.data),
  )(records) as Array<types.Record<types.TimeDistanceRecord>>

  /*
    const timeDistanceActivities: Array<TimeDistanceActivity> = _.uniq(
      history
        .timeDistanceWorkouts()
        .filter(td => isSomething(td))
        .map(td => td.activity),
    )
    console.log("Summary: ", timeDistanceActivities)
    */

  return (
    <div>
      <div>
        Weight Change:
        {math.format(weightChange.toNumber(prefs.units.mass), {
          notation: "fixed",
          precision: 2,
        })}
        {prefs.units.massRepr.tr(prefs.language)}
      </div>
    </div>
  )
}

/*
        <div>
          {" "}
          {isSomething(startWeight)
            ? startWeight.weight.to("kg").format(4)
            : "--"}{" "}
          -&gt;
          {isSomething(endWeight)
            ? endWeight.weight.to("kg").format(4)
            : "--"}{" "}
        </div>
        <table>
          <tbody>
            {timeDistanceActivities.map(a => (
              <TimeDistanceSummary
                activity={a}
                entries={history.timeDistanceWorkouts()}
              />
            ))}
          </tbody>
        </table>
        */

/*
            <table className="table">
            <tbody>
            <tr> <td> Cycling </td>
                 <td> </td>
                 <td> {renderDistance(tdw.filter(e => e.activity == 'Cycling').map(w => w.distance, 'm').reduce((a, b) => math.add(a, b), math.unit(0, 'm')))} km </td>
                 <td> {renderDuration(sum(tdw.filter(e => e.activity == 'Cycling').map(w => w.duration)))} </td>
                 </tr>
            </tbody>
            </table>
            */

/*
            <table className="table">
            <tbody>
            <tr> <td> Crunches </td> <td> {sum([].concat.apply([], srw.filter(e => e.activity == 'Crunches').map(w => w.sets)))} </td> </tr>
            <tr> <td> Pushups </td> <td> {sum([].concat.apply([], srw.filter(e => e.activity == 'Pushups').map(w => w.sets)))} </td> </tr>
            </tbody>
            </table>
            */

/*
const renderDistance = d => d.to("km").toNumber()
const renderDuration = t => {
  let [hr, sec] = divmod(t, 3600)
  let [min, sec_] = divmod(sec, 60)
  if (hr > 0) {
    return intercalate(
      [hr, padStr(min.toString(), "0", 2), padStr(sec_.toString(), "0", 2)],
      ":",
    )
  } else {
    return intercalate([min, padStr(sec_.toString(), "0", 2)], ":")
  }
}
*/

export default RangeSummary
