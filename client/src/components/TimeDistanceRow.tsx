import React from "react"
import math from "mathjs"
import moment from "moment"
import "moment-duration-format"

import {
  divmod,
  intercalate,
  padStr,
  parseUnit,
  parseTime,
  renderTime,
  renderDistance,
  parseDuration,
  renderDuration,
} from "../common"
import { TextEditForm } from "./ValidatedText"
import { TimeDistanceActivity, TimeDistanceSample } from "../types"

const distanceFieldStyle = {
  display: "inline",
  padding: 1,
  margin: 0,
  width: "4em",
}
const setsFieldStyle = { display: "inline", padding: 1, margin: 0 }

/* Give this an "edit" field so that the user can edit the data in the component */
export const TimeDistance = ({
  data: record,
}: {
  data: TimeDistanceSample
}) => (
  <tr key={record.id}>
    <td> {renderTime(record.date)} </td>
    <td> {record.activity} </td>
    <td> {renderDistance(record.distance)} </td>
    <td> {renderDuration(record.duration)} </td>
    <td> </td>
  </tr>
)

export interface TimeDistanceEditProps {
  activity: any
  record?: TimeDistanceSample
  onUpdateDate: (moment) => void
  onUpdateDistance: (any) => void
  onUpdateDuration: (any) => void
}

export const TimeDistanceEdit = ({
  record,
  onUpdateDate,
  onUpdateDistance,
  onUpdateDuration,
}: TimeDistanceEditProps) => (
  <tr key={record.id ? record.id : "new-row"}>
    <td>
      <TextEditForm
        value={record.date ? record.date : moment()}
        render={renderTime}
        parse={parseTime}
        onUpdate={value => onUpdateDate(value)}
      />
    </td>
    <td> {record.activity} </td>
    <td>
      <TextEditForm
        value={record.distance ? record.distance : math.unit(0, "km")}
        render={renderDistance}
        parse={parseUnit}
        onUpdate={value => onUpdateDistance(value)}
      />
    </td>
    <td>
      <TextEditForm
        value={record.duration ? record.duration : moment.duration(0, "s")}
        render={renderDuration}
        parse={parseDuration}
        onUpdate={value => onUpdateDuration(value)}
      />
    </td>
  </tr>
)

export const TimeDistanceSummary = ({
  entries,
  activity,
}: {
  entries: Array<TimeDistanceSample>
  activity: TimeDistanceActivity
}) => {
  const entries_ = entries.filter(td => td.activity == this.props.activity)
  const distance = entries_
    .map(td => td.distance)
    .reduce((a, b) => math.add(a, b), math.unit(0, "km"))
  const duration = entries_
    .map(td => td.duration)
    .reduce((a, b) => a.add(b), moment.duration(0))
  return (
    <tr>
      <th> {this.props.activity} </th>
      <td> {renderDistance(distance)} </td>
      <td> {renderDuration(duration)} </td>{" "}
    </tr>
  )
}
