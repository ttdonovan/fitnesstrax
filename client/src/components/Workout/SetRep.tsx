import { Option, Result } from "ld-ambiguity"
import _ from "lodash/fp"
import * as luxon from "luxon"
import React from "react"
import Select from "react-select"

import { classnames, ClassNames } from "../../classnames"
import { Date, DateTimeTz } from "../../datetimetz"
import * as i18n from "../../i18n"
import { parseTime } from "../../parsers"
import { UserPreferences } from "../../settings"
import * as types from "../../types"
import { SetsView, SetsEdit } from "../Sets"
import ValidatedInputField from "../ValidatedInputField"

interface ViewProps {
  prefs: UserPreferences
  record: types.Record<types.SetRepRecord>
}

export const SetRepRecordView: React.SFC<ViewProps> = ({ prefs, record }) => (
  <div className="setrep-view l-3-column">
    <div className="activity">
      {record.data.activity.repr.tr(prefs.language)}
    </div>
    <div className="sets">
      <SetsView sets={record.data.sets} />
    </div>
  </div>
)

interface EditProps {
  prefs: UserPreferences
  uuid: Option<string>
  record: types.SetRepRecord
  save: (
    uuid: Option<string>,
    data: types.RecordTypes,
  ) => Promise<Result<null, string>>
  cancel: () => void
}

interface EditState {
  time: Option<DateTimeTz>
  activity: types.SetRepActivity
  sets: Array<number>
}

export class SetRepRecordEdit extends React.Component<EditProps, EditState> {
  constructor(props: EditProps) {
    super(props)
    this.state = {
      time: props.uuid.isSome()
        ? Option.Some(props.record.date)
        : Option.None(),
      activity: props.record.activity,
      sets: props.record.sets,
    }
  }

  onSave = () => {
    this.props
      .save(
        this.props.uuid,
        new types.SetRepRecord(
          this.props.record.date,
          this.state.activity,
          this.state.sets,
        ),
      )
      .then(result => (result.isOk() ? this.props.cancel() : null))
  }

  onChangeTime(inp: Option<DateTimeTz>) {
    this.setState({ time: inp })
  }

  onChangeActivity(inp: { label: string; value: types.SetRepActivity }) {
    this.setState({ activity: inp.value })
  }

  render = () => {
    const { prefs, record } = this.props

    return (
      <div className="setrep-edit l-3-column">
        <div className="activity">
          <Select
            style={{ width: "100%" }}
            name="activity-selection"
            defaultValue={{
              label: this.state.activity.repr.tr(prefs.language),
              value: this.state.activity,
            }}
            options={_.map((activity: types.SetRepActivity): {
              value: types.SetRepActivity
              label: string
            } => ({
              value: activity,
              label: activity.repr.tr(prefs.language),
            }))([types.Pushups, types.Situps])}
            onChange={(evt: any) => this.onChangeActivity(evt)}
          />
        </div>
        <div className="sets">
          <SetsEdit
            sets={record.sets}
            onChange={inp => {
              console.log(`onChange ${inp}`)
              this.setState({ sets: inp.unwrap() })
            }}
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
  record: types.Record<types.SetRepRecord>
  save: (
    uuid: Option<string>,
    data: types.RecordTypes,
  ) => Promise<Result<null, string>>
}

interface State {
  editing: boolean
}

class SetRepRecordComponent extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props)
    this.state = { editing: false }
  }

  cancel = () => this.setState({ editing: false })

  render = () => {
    const { prefs, record, save } = this.props
    const { editing } = this.state
    return editing ? (
      <SetRepRecordEdit
        prefs={prefs}
        uuid={Option.Some(record.id)}
        record={record.data}
        save={save}
        cancel={this.cancel}
      />
    ) : (
      <div onClick={() => this.setState({ editing: true })}>
        <SetRepRecordView prefs={prefs} record={record} />
      </div>
    )
  }
}

export default SetRepRecordComponent
