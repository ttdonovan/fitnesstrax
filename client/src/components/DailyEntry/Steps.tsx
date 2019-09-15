import { Option, Result } from "ld-ambiguity"
import React from "react"

import { classnames, ClassNames } from "../../classnames"
import { DateTimeTz, Date } from "../../datetimetz"
import * as i18n from "../../i18n"
import { parseNumber } from "../../parsers"
import { UserPreferences } from "../../settings"
import * as types from "../../types"
import ValidatedInputField from "../ValidatedInputField"

interface ViewProps {
  prefs: UserPreferences
  record: Option<types.Record<types.StepRecord>>
}

const StepRecordView: React.SFC<ViewProps> = ({ prefs, record }) => (
  <div
    className={classnames({
      steps: true,
      view: true,
      placeholder: record.isNone(),
    })}
  >
    {record
      .map(r => `${r.data.steps} ${i18n.Steps.tr(prefs.language)}`)
      .or(i18n.Steps.tr(prefs.language))}
  </div>
)

interface EditProps {
  prefs: UserPreferences
  date: Date
  record: Option<types.Record<types.StepRecord>>
  save: (
    uuid: Option<string>,
    data: types.RecordTypes,
  ) => Promise<Result<null, string>>
  cancel: () => void
}

interface EditState {
  steps: Option<number>
}

interface Event {
  value: string
}

class StepRecordEdit extends React.Component<EditProps, EditState> {
  constructor(props: EditProps) {
    super(props)
    this.state = {
      steps: this.props.record.map(r => r.data.steps),
    }
  }

  onSave = () => {
    const steps = this.state.steps.unwrap_()

    if (steps) {
      this.props
        .save(
          this.props.record.map(r => r.id),
          new types.StepRecord(
            DateTimeTz.fromDate(this.props.date, this.props.prefs.timezone),
            steps,
          ),
        )
        .then(result => (result.isOk() ? this.props.cancel() : null))
    }
  }

  render() {
    const { date, prefs, record } = this.props
    return (
      <div className="steps">
        <ValidatedInputField
          value={record.map(r => r.data.steps)}
          placeholder={i18n.Steps.tr(prefs.language)}
          render={(val: number): string => `${val}`}
          parse={(inp: string): Result<Option<number>, string> =>
            parseNumber(inp)
          }
          onChange={inp => this.setState({ steps: inp })}
        />
        <button onClick={this.onSave}>Save</button>
        <button onClick={() => this.props.cancel()}>Cancel</button>
      </div>
    )
  }
}

interface Props {
  prefs: UserPreferences
  date: Date
  record: Option<types.Record<types.StepRecord>>
  save: (
    uuid: Option<string>,
    data: types.RecordTypes,
  ) => Promise<Result<null, string>>
}

interface State {
  editing: boolean
}

class StepRecordComponent extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props)
    this.state = { editing: false }
  }

  cancel = () => {
    this.setState({ editing: false })
  }

  render = () => {
    const { prefs, date, record, save } = this.props
    const { editing } = this.state
    return editing ? (
      <StepRecordEdit
        date={date}
        prefs={prefs}
        record={record}
        save={save}
        cancel={this.cancel}
      />
    ) : (
      <div onClick={() => this.setState({ editing: true })}>
        <StepRecordView prefs={prefs} record={record} />
      </div>
    )
  }
}

export default StepRecordComponent
