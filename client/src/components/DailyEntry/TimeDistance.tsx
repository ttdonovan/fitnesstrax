import { Option } from "ld-ambiguity"
import _ from "lodash/fp"
import { DateTime, Duration } from "luxon"
import math from "mathjs"
import React from "react"
import Select from "react-select"
import uuidv4 from "uuid/v4"

import { classnames, ClassNames } from "../../classnames"
import {
  renderDistance,
  parseDuration,
  renderDuration,
  parseTime,
} from "../../common"
import { Date, DateTimeTz } from "../../datetimetz"
import * as i18n from "../../i18n"
import { UserPreferences } from "../../settings"
import * as types from "../../types"
import ValidatedInputField from "../ValidatedInputField"

import trace from "../../trace"

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
        .map(d => renderDistance(d, prefs.units, prefs.language))
        .or("")}
    </div>
    <div>{record.data.duration.map(d => renderDuration(d)).or("")}</div>
  </div>
)

interface EditProps {
  prefs: UserPreferences
  date: Date
  record: Option<types.Record<types.TimeDistanceRecord>>
  onUpdateNew: (uuid: string, data: types.TimeDistanceRecord) => void
  onUpdate: (record: types.Record<types.TimeDistanceRecord>) => void
}

interface EditState {
  uuid: string
  time: Option<DateTimeTz>
  activity: Option<types.TimeDistanceActivity>
  distance: Option<math.Unit>
  duration: Option<Duration>
}

export class TimeDistanceRecordEdit extends React.Component<
  EditProps,
  EditState
> {
  constructor(props: EditProps) {
    super(props)
    this.state = {
      uuid: props.record.map(r => r.id).or(uuidv4()),
      time: props.record.map(r => r.data.date),
      activity: props.record.map(r => r.data.activity),
      distance: props.record.andThen(r => r.data.distance),
      duration: props.record.andThen(r => r.data.duration),
    }
  }

  stateIsValid(st: EditState): boolean {
    return st.time.isSome() && st.activity.isSome()
  }

  sendRecord(st: EditState) {
    const { record, onUpdate, onUpdateNew } = this.props
    const { uuid } = this.state

    console.log("sendRecord", st)

    if (this.stateIsValid(st)) {
      const td = new types.TimeDistanceRecord(
        st.time.unwrap(),
        st.activity.unwrap(),
        st.distance,
        st.duration,
        Option.None(),
      )
      if (record.isSome()) {
        this.props.onUpdate(new types.Record(record.unwrap().id, td))
      } else {
        onUpdateNew(uuid, td)
      }
    }
  }

  onChangeTime(inp: DateTimeTz) {
    const newState = { ...this.state, time: Option.Some(inp) }
    this.setState({ time: Option.Some(inp) })
    this.sendRecord(newState)
  }
  onChangeActivity(inp: { label: string; value: types.TimeDistanceActivity }) {
    const newState = { ...this.state, activity: Option.Some(inp.value) }
    this.setState({ activity: Option.Some(inp.value) })
    this.sendRecord(newState)
  }
  onChangeDistance(inp: math.Unit) {
    const newState = { ...this.state, distance: Option.Some(inp) }
    this.setState({ distance: Option.Some(inp) })
    this.sendRecord(newState)
  }
  onChangeDuration(inp: Duration) {
    const newState = { ...this.state, duration: Option.Some(inp) }
    this.setState({ duration: Option.Some(inp) })
    this.sendRecord(newState)
  }

  render() {
    const { date, prefs, record } = this.props
    return (
      <div className="record timedistance">
        <div>
          <ValidatedInputField
            value={record.map(r => r.data.date)}
            placeholder={i18n.TimeEntryPlaceholder.tr(prefs.language)}
            render={v =>
              v.map(dt => dt.setZone(prefs.timezone)).toFormat("HH:mm:ss")
            }
            parse={(inp: string): Option<DateTimeTz> =>
              parseTime(inp).map(
                t =>
                  new DateTimeTz(
                    DateTime.fromObject({
                      year: date.year,
                      month: date.month,
                      day: date.day,
                      hour: t.hours,
                      minute: t.minutes,
                      second: t.seconds,
                      zone: prefs.timezone,
                    }),
                  ),
              )
            }
            onChange={inp => this.onChangeTime(inp)}
          />
        </div>
        <div>
          <Select
            style={{ width: "100%" }}
            name="activity-selection"
            defaultValue={record
              .map(r => ({
                label: r.data.activity.repr.tr(prefs.language),
                value: r.data.activity,
              }))
              .unwrap_()}
            options={_.map((activity: types.TimeDistanceActivity) => ({
              value: activity,
              label: activity.repr.tr(prefs.language),
            }))([types.Cycling, types.Running])}
            onChange={(evt: any) => this.onChangeActivity(evt)}
          />
        </div>
        <div>
          <ValidatedInputField
            value={record.andThen(r => r.data.distance)}
            placeholder={i18n.DistanceEntryPlaceholder.tr(prefs.language)}
            render={d => renderDistance(d, prefs.units)}
            parse={str =>
              Option.fromNaN(parseFloat(str)).map(v =>
                math.unit(v, prefs.units.length),
              )
            }
            onChange={inp => this.onChangeDistance(inp)}
          />
          {prefs.units.length}
        </div>
        <div>
          <ValidatedInputField
            value={record.andThen(r => r.data.duration)}
            placeholder={i18n.DurationEntryPlaceholder.tr(prefs.language)}
            render={d => renderDuration(d)}
            parse={str => parseDuration(str)}
            onChange={inp => this.onChangeDuration(inp)}
          />
        </div>
      </div>
    )
  }
}
