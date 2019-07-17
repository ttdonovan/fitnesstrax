import math from "mathjs"
import * as luxon from "luxon"
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
import Distance from "../Distance"
import Duration from "../Duration"

interface Props {
  prefs: UserPreferences
  records: Array<types.Record<types.RecordTypes>>
}

const Summary: React.SFC<Props> = ({ prefs, records }: Props) => {
  const tdr = _.filter(
    (r: types.Record<types.RecordTypes>): boolean =>
      types.isTimeDistanceRecord(r.data),
  )(records) as Array<types.Record<types.TimeDistanceRecord>>

  const totalDistance: math.Unit = _.compose(
    _.reduce(
      (d: math.Unit, acc: math.Unit): math.Unit =>
        math.add(d, acc) as math.Unit,
      math.unit(0, "km"),
    ),
    _.map(
      (r: types.Record<types.TimeDistanceRecord>): math.Unit =>
        r.data.distance.or(math.unit(0, "km")),
    ),
  )(tdr)

  const totalDuration: luxon.Duration = _.compose(
    _.reduce(
      (d: luxon.Duration, acc: luxon.Duration): luxon.Duration => acc.plus(d),
      luxon.Duration.fromObject({ seconds: 0 }),
    ),
    _.map(
      (r: types.Record<types.TimeDistanceRecord>): luxon.Duration =>
        r.data.duration.or(luxon.Duration.fromObject({ seconds: 0 })),
    ),
  )(tdr)

  return (
    <div className="day-summary">
      <div>
        <Distance distance={totalDistance} prefs={prefs} />
      </div>
      <div>
        <Duration duration={totalDuration} />
      </div>
    </div>
  )
}

export default Summary
