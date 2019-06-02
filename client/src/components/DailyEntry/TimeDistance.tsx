import React from "react"
import { classnames, ClassNames } from "../../classnames"

import * as types from "../../types"
import Duration from "../Duration"

interface Props {
  record: types.TimeDistanceRecord
}

const TimeDistanceRecord: React.SFC<Props> = ({ record }) => (
  <div className="record timedistance">
    <div>{record.date.toString()}</div>
    <div>{types.timeDistanceActivityToString(record.activity)}</div>
    <div>{record.distance.map(d => d.toString()).unwrap()}</div>
    <div>
      <Duration duration={record.duration} />
    </div>
  </div>
)

export default TimeDistanceRecord
