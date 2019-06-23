import math from "mathjs"
import React from "react"
import { classnames, ClassNames } from "../../classnames"
import { UserPreferences } from "../../userPrefs"

import * as types from "../../types"
import Duration from "../Duration"

interface Props {
  prefs: UserPreferences
  record: types.TimeDistanceRecord
}

export const TimeDistanceRecordView: React.SFC<Props> = ({ prefs, record }) => (
  <div className="record timedistance">
    <div>
      {record.date.map(dt => dt.setZone(prefs.timezone)).toFormat("HH:mm:ss")}
    </div>
    <div>{record.activity.repr.tr(prefs.language)}</div>
    <div>
      {record.distance
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
      <Duration duration={record.duration} />
    </div>
  </div>
)

export const TimeDistanceRecordEdit: React.SFC<Props> = ({ prefs, record }) => (
  <div className="record timedistance">
    <div>
      {record.date.map(dt => dt.setZone(prefs.timezone)).toFormat("HH:mm:ss")}
    </div>
    <div>{record.activity.repr.tr(prefs.language)}</div>
    <div>
      {record.distance
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
      <Duration duration={record.duration} />
    </div>
  </div>
)
