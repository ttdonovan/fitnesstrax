import math from "mathjs"
import React from "react"
import { classnames, ClassNames } from "../../classnames"
import { UserPreferences } from "../../settings"

import * as types from "../../types"
import Duration from "../Duration"

interface Props {
  prefs: UserPreferences
  record: types.Record<types.TimeDistanceRecord>
}

export const TimeDistanceRecordView: React.SFC<Props> = ({ prefs, record }) => (
  <div className="record timedistance">
    <div>
      {record.data.date
        .map(dt => dt.setZone(prefs.timezone))
        .toFormat("HH:mm:ss")}
    </div>
    <div>{record.data.activity.repr.tr(prefs.language)}</div>
    <div>
      {record.data.distance
        .map(
          d =>
            `${math.format(d.toNumber(prefs.units.length), {
              notation: "fixed",
              precision: 2,
            })} ${prefs.units.lengthRepr.tr(prefs.language)}`,
        )
        .unwrap()}
    </div>
    <div>
      <Duration duration={record.data.duration} />
    </div>
  </div>
)

export const TimeDistanceRecordEdit: React.SFC<Props> = ({ prefs, record }) => (
  <div className="record timedistance">
    <div>
      {record.data.date
        .map(dt => dt.setZone(prefs.timezone))
        .toFormat("HH:mm:ss")}
    </div>
    <div>{record.data.activity.repr.tr(prefs.language)}</div>
    <div>
      {record.data.distance
        .map(
          d =>
            `${math.format(d.toNumber(prefs.units.length), {
              notation: "fixed",
              precision: 2,
            })} ${prefs.units.lengthRepr.tr(prefs.language)}`,
        )
        .unwrap()}
    </div>
    <div>
      <Duration duration={record.data.duration} />
    </div>
  </div>
)
