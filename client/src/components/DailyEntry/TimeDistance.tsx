import { Option, Result } from "ld-ambiguity"
import _ from "lodash/fp"
import { DateTime, Duration } from "luxon"
import math from "mathjs"
import React from "react"
import Select from "react-select"
import uuidv4 from "uuid/v4"

import { classnames, ClassNames } from "../../classnames"
import { renderDistance, renderDuration } from "../../common"
import { parseDuration, parseNumber, parseTime } from "../../parsers"
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
  <div className="timedistance-view">
    <div className="date">
      {record.data.date
        .map(dt => dt.setZone(prefs.timezone))
        .toFormat("HH:mm:ss")}
    </div>
    <div className="activity">
      {record.data.activity.repr.tr(prefs.language)}
    </div>
    <div className="distance">
      {record.data.distance
        .map(d => renderDistance(d, prefs.units, prefs.language))
        .or("")}
    </div>
    <div className="duration">
      {record.data.duration.map(d => renderDuration(d)).or("")}
    </div>
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

  onChangeTime(inp: Option<DateTimeTz>) {
    const newState = { ...this.state, time: inp }
    this.setState({ time: inp })
    this.sendRecord(newState)
  }
  onChangeActivity(inp: { label: string; value: types.TimeDistanceActivity }) {
    const newState = { ...this.state, activity: Option.Some(inp.value) }
    this.setState({ activity: Option.Some(inp.value) })
    this.sendRecord(newState)
  }
  onChangeDistance(inp: Option<math.Unit>) {
    const newState = { ...this.state, distance: inp }
    this.setState({ distance: inp })
    this.sendRecord(newState)
  }
  onChangeDuration(inp: Option<Duration>) {
    const newState = { ...this.state, duration: inp }
    this.setState({ duration: inp })
    this.sendRecord(newState)
  }

  render() {
    const { date, prefs, record } = this.props
    return (
      <div className="timedistance-edit">
        <div className="date">
          <ValidatedInputField
            value={record.map(r => r.data.date)}
            placeholder={i18n.TimeEntryPlaceholder.tr(prefs.language)}
            render={v =>
              v.map(dt => dt.setZone(prefs.timezone)).toFormat("HH:mm:ss")
            }
            parse={(inp: string): Result<Option<DateTimeTz>, string> => {
              if (inp === "") return Result.Ok(Option.None())
              return parseTime(inp).map(t =>
                t.map(
                  t_ =>
                    new DateTimeTz(
                      DateTime.fromObject({
                        year: date.year,
                        month: date.month,
                        day: date.day,
                        hour: t_.hours,
                        minute: t_.minutes,
                        second: t_.seconds,
                        zone: prefs.timezone,
                      }),
                    ),
                ),
              )
            }}
            onChange={inp => this.onChangeTime(inp)}
          />
        </div>
        <div className="activity">
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
            }))([types.Cycling, types.Running, types.Walking])}
            onChange={(evt: any) => this.onChangeActivity(evt)}
          />
        </div>
        <div className="distance">
          <ValidatedInputField
            value={record.andThen(r => r.data.distance)}
            placeholder={i18n.DistanceEntryPlaceholder.tr(prefs.language)}
            render={d => renderDistance(d, prefs.units)}
            parse={str => {
              if (str === "") return Result.Ok(Option.None())
              return parseNumber(str).map(n =>
                n.map(n_ => math.unit(n_, prefs.units.length)),
              )
            }}
            onChange={inp => this.onChangeDistance(inp)}
          />
          {prefs.units.length}
        </div>
        <div className="duration">
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
