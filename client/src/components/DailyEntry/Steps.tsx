import { Option, Result } from "ld-ambiguity"
import React from "react"
import uuidv4 from "uuid/v4"

import { classnames, ClassNames } from "../../classnames"
import { DateTimeTz, Date } from "../../datetimetz"
import * as i18n from "../../i18n"
import { parseNumber } from "../../parsers"
import { UserPreferences } from "../../settings"
import * as types from "../../types"
import ValidatedInputField from "../ValidatedInputField"

interface ViewProps {
  prefs: UserPreferences
  record: types.Record<types.StepRecord>
}

export const StepRecordView: React.SFC<ViewProps> = ({ prefs, record }) => (
  <div className="seps">
    {record.data.steps} {i18n.Steps.tr(prefs.language)}
  </div>
)

interface EditProps {
  prefs: UserPreferences
  date: Date
  record: Option<types.Record<types.StepRecord>>
  onUpdateNew: (uuid: string, data: types.StepRecord) => void
  onUpdate: (record: types.Record<types.StepRecord>) => void
}

interface State {
  uuid: Option<string>
  steps: Option<number>
}

interface Event {
  value: string
}

export class StepRecordEdit extends React.Component<EditProps, State> {
  constructor(props: EditProps) {
    super(props)
    this.state = {
      uuid: Option.None(),
      steps: this.props.record.map(r => r.data.steps),
    }
  }

  onChange = (inp: Option<number>) => {
    const { date, prefs, record, onUpdate, onUpdateNew } = this.props
    const { uuid, steps } = this.state

    const uuid_ = uuid.or(uuidv4())
    this.setState({ uuid: Option.Some(uuid_) })

    if (inp.isSome()) {
      if (record.isSome()) {
        this.props.onUpdate(
          new types.Record(
            record.unwrap().id,
            record.unwrap().data.withSteps(inp.unwrap()),
          ),
        )
      } else {
        this.props.onUpdateNew(
          uuid_,
          new types.StepRecord(
            DateTimeTz.fromDate(date, prefs.timezone),
            inp.unwrap(),
          ),
        )
      }
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
          onChange={this.onChange}
        />
      </div>
    )
  }
}
