import { Option, Result } from "ld-ambiguity"
import _ from "lodash/fp"
import * as luxon from "luxon"
import math from "mathjs"
import React from "react"
import Select from "react-select"

import { classnames, ClassNames } from "../../classnames"
import { renderDistance } from "../../common"
import { parseDuration, parseNumber, parseTime } from "../../parsers"
import { Date, DateTimeTz } from "../../datetimetz"
import * as i18n from "../../i18n"
import { UserPreferences } from "../../settings"
import * as types from "../../types"
import { DistanceView, DistanceEdit } from "../Distance"
import { DurationView, DurationEdit } from "../Duration"
import ValidatedInputField from "../ValidatedInputField"

interface ViewProps {
  prefs: UserPreferences
  record: types.Record<types.TimeDistanceRecord>
}

export const TimeDistanceRecordView: React.SFC<ViewProps> = ({
  prefs,
  record,
}) => (
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
        .map(d => <DistanceView distance={d} prefs={prefs} />)

        .or(<React.Fragment />)}
    </div>
    <div className="duration">
      {record.data.duration
        .map(d => <DurationView duration={d} />)
        .or(<React.Fragment />)}
    </div>
  </div>
)

interface EditProps {
  prefs: UserPreferences
  uuid: Option<string>
  record: types.TimeDistanceRecord
  save: (
    uuid: Option<string>,
    data: types.RecordTypes,
  ) => Promise<Result<null, string>>
  cancel: () => void
}

interface EditState {
  time: Option<DateTimeTz>
  activity: types.TimeDistanceActivity
  distance: Option<math.Unit>
  duration: Option<luxon.Duration>
}

export class TimeDistanceRecordEdit extends React.Component<
  EditProps,
  EditState
> {
  constructor(props: EditProps) {
    super(props)
    this.state = {
      time: props.uuid.isSome()
        ? Option.Some(props.record.date)
        : Option.None(),
      activity: props.record.activity,
      distance: props.record.distance,
      duration: props.record.duration,
    }
  }

  isStateValid = (st: EditState) => this.state.time.isSome()

  onSave = () => {
    if (this.isStateValid(this.state)) {
      const td = new types.TimeDistanceRecord(
        this.state.time.unwrap(),
        this.state.activity,
        this.state.distance,
        this.state.duration,
        Option.None(),
      )

      this.props
        .save(this.props.uuid, td)
        .then(result => (result.isOk() ? this.props.cancel() : null))
    }
  }

  onChangeTime(inp: Option<DateTimeTz>) {
    this.setState({ time: inp })
  }
  onChangeActivity(inp: { label: string; value: types.TimeDistanceActivity }) {
    this.setState({ activity: inp.value })
  }
  onChangeDistance(inp: Option<math.Unit>) {
    this.setState({ distance: inp })
  }
  onChangeDuration(inp: Option<luxon.Duration>) {
    this.setState({ duration: inp })
  }

  render() {
    const { prefs, record } = this.props
    console.log(`render: ${JSON.stringify(this.state)}`)
    return (
      <div className="timedistance-edit">
        <div className="date">
          <ValidatedInputField
            value={Option.Some(record.date)}
            placeholder={i18n.TimeEntryPlaceholder.tr(prefs.language)}
            render={v =>
              v.map(dt => dt.setZone(prefs.timezone)).toFormat("HH:mm:ss")
            }
            parse={(inp: string): Result<Option<DateTimeTz>, string> => {
              if (inp === "") return Result.Ok(Option.None())
              return parseTime(inp).map(t =>
                t.map(t_ =>
                  record.date.map(ts =>
                    luxon.DateTime.fromObject({
                      year: ts.year,
                      month: ts.month,
                      day: ts.day,
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
            defaultValue={{
              label: this.state.activity.repr.tr(prefs.language),
              value: this.state.activity,
            }}
            options={_.map((activity: types.TimeDistanceActivity) => ({
              value: activity,
              label: activity.repr.tr(prefs.language),
            }))([types.Cycling, types.Running, types.Swimming, types.Walking])}
            onChange={(evt: any) => this.onChangeActivity(evt)}
          />
        </div>
        <div className="distance">
          <DistanceEdit
            distance={record.distance}
            onChange={inp => this.onChangeDistance(inp)}
            prefs={prefs}
          />
        </div>
        <div className="duration">
          <DurationEdit
            duration={record.duration}
            onChange={inp => this.onChangeDuration(inp)}
            prefs={prefs}
          />
        </div>
        <div>
          <button onClick={this.onSave}>{i18n.Save.tr(prefs.language)}</button>
          <button onClick={this.props.cancel}>
            {i18n.Cancel.tr(prefs.language)}
          </button>
        </div>
      </div>
    )
  }
}

interface Props {
  prefs: UserPreferences
  record: types.Record<types.TimeDistanceRecord>
  save: (
    uuid: Option<string>,
    data: types.RecordTypes,
  ) => Promise<Result<null, string>>
}

interface State {
  editing: boolean
}

class TimeDistanceRecordComponent extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props)
    this.state = { editing: false }
  }

  cancel = () => this.setState({ editing: false })

  render = () => {
    const { prefs, record, save } = this.props
    const { editing } = this.state
    return editing ? (
      <TimeDistanceRecordEdit
        prefs={prefs}
        uuid={Option.Some(record.id)}
        record={record.data}
        save={save}
        cancel={this.cancel}
      />
    ) : (
      <div onClick={() => this.setState({ editing: true })}>
        <TimeDistanceRecordView prefs={prefs} record={record} />
      </div>
    )
  }
}

export default TimeDistanceRecordComponent
