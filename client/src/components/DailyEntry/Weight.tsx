import { Option, Result } from "ld-ambiguity"
import math from "mathjs"
import React from "react"
import uuidv4 from "uuid/v4"

import { classnames, ClassNames } from "../../classnames"
import { DateTimeTz, Date } from "../../datetimetz"
import * as i18n from "../../i18n"
import { parseNumber } from "../../parsers"
import { UserPreferences } from "../../settings"
import * as types from "../../types"
import ValidatedInputField from "../ValidatedInputField"
import Weight from "../Weight"

interface ViewProps {
  prefs: UserPreferences
  record: Option<types.Record<types.WeightRecord>>
}

export const WeightRecordView: React.SFC<ViewProps> = ({ prefs, record }) => (
  <div
    className={classnames({
      weight: true,
      view: true,
      placeholder: record.isNone(),
    })}
  >
    {record
      .map(r => <Weight weight={r.data.weight} prefs={prefs} />)
      .or(<span>{i18n.Weight.tr(prefs.language)}</span>)}
  </div>
)

interface EditProps {
  prefs: UserPreferences
  date: Date
  record: Option<types.Record<types.WeightRecord>>
  save: (
    uuid: Option<string>,
    data: types.RecordTypes,
  ) => Promise<Result<null, string>>
  cancel: () => void
}

interface EditState {
  weight: Option<math.Unit>
}

export class WeightRecordEdit extends React.Component<EditProps, EditState> {
  constructor(props: EditProps) {
    super(props)
    this.state = {
      weight: this.props.record.map(w => w.data.weight),
    }
  }

  onSave = () => {
    const weight = this.state.weight.unwrap_()

    if (weight) {
      this.props
        .save(
          this.props.record.map(r => r.id),
          new types.WeightRecord(
            DateTimeTz.fromDate(this.props.date, this.props.prefs.timezone),
            weight,
          ),
        )
        .then(result => (result.isOk() ? this.props.cancel() : null))
    }
  }

  render() {
    const { date, prefs, record } = this.props
    return (
      <div className="weight">
        <ValidatedInputField
          value={record.map(r => r.data.weight)}
          placeholder={i18n.Weight.tr(prefs.language)}
          render={(val: math.Unit): string =>
            math.format(val.toNumber(prefs.units.mass), {
              notation: "fixed",
              precision: 2,
            })
          }
          parse={(inp: string): Result<Option<math.Unit>, string> =>
            parseNumber(inp).map(v =>
              v.map(v_ => math.unit(v_, this.props.prefs.units.mass)),
            )
          }
          onChange={inp => this.setState({ weight: inp })}
        />
        {prefs.units.massRepr.tr(prefs.language)}
        <button onClick={this.onSave}>Save</button>
        <button onClick={this.props.cancel}>Cancel</button>
      </div>
    )
  }
}

interface Props {
  prefs: UserPreferences
  date: Date
  record: Option<types.Record<types.WeightRecord>>
  save: (
    uuid: Option<string>,
    data: types.RecordTypes,
  ) => Promise<Result<null, string>>
}

interface State {
  editing: boolean
}

class WeightRecordComponent extends React.Component<Props, State> {
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
      <WeightRecordEdit
        date={date}
        prefs={prefs}
        record={record}
        save={save}
        cancel={this.cancel}
      />
    ) : (
      <div onClick={() => this.setState({ editing: true })}>
        <WeightRecordView prefs={prefs} record={record} />
      </div>
    )
  }
}

export default WeightRecordComponent
