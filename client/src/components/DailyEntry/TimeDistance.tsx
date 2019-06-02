import React from "react"
import { classnames, ClassNames } from "../../classnames"

import * as types from "../../types"

interface Props {
  record: types.TimeDistanceRecord
}

const TimeDistanceRecord: React.SFC<Props> = ({ record }) => (
  <div>
    <div>{record.date.toString()}</div>
    <div>{types.timeDistanceActivityToString(record.activity)}</div>
    <div>{record.distance.map(d => d.toString()).unwrap()}</div>
    <div>{record.duration.map(d => d.toString()).unwrap()}</div>
  </div>
)

export default TimeDistanceRecord
