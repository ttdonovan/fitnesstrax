import math from "mathjs"
import React from "react"
import { connect } from "react-redux"
import _ from "lodash/fp"

import { first, isSomething, intercalate, sum, divmod, padStr } from "../common"
import { getHistory } from "../state/state"
import { TimeDistanceActivity } from "../types"
import { TimeDistanceSummary } from "./TimeDistanceRow"

const Summary = ({ history }: { history: any }) => {
  if (isSomething(history)) {
    const weights = history
      .weights()
      .filter(w => isSomething(w))
      .sort((a, b) => a.date >= b.date)
    const startWeight = first(weights)
    const endWeight = first(weights.slice().reverse())

    console.log("Summary: ", history.timeDistanceWorkouts())
    const timeDistanceActivities: Array<TimeDistanceActivity> = _.uniq(
      history
        .timeDistanceWorkouts()
        .filter(td => isSomething(td))
        .map(td => td.activity),
    )
    console.log("Summary: ", timeDistanceActivities)

    return (
      <div>
        <h2> Summary </h2>
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
      </div>
    )
  } else {
    return (
      <div>
        {" "}
        <h2> Summary </h2> <div> No data </div>{" "}
      </div>
    )
  }
}

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

export const SummaryView = connect(
  state => ({ history: getHistory(state) }),
  dispatch => ({}),
)(Summary)

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
