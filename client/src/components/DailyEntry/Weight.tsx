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
  record: types.Record<types.WeightRecord>
}

export const WeightRecordView: React.SFC<ViewProps> = ({ prefs, record }) => (
  <div className="weight">
    <div>
      <Weight weight={record.data.weight} prefs={prefs} />
    </div>
  </div>
)

interface EditProps {
  prefs: UserPreferences
  date: Date
  record: Option<types.Record<types.WeightRecord>>
  onUpdateNew: (uuid: string, data: types.WeightRecord) => void
  onUpdate: (record: types.Record<types.WeightRecord>) => void
}

interface State {
  uuid: Option<string>
  weight: Option<math.Unit>
}

interface Event {
  value: string
}

export class WeightRecordEdit extends React.Component<EditProps, State> {
  constructor(props: EditProps) {
    super(props)
    this.state = {
      uuid: Option.None(),
      weight: this.props.record.map(w => w.data.weight),
    }
  }

  onChange = (inp: Option<math.Unit>) => {
    const { date, prefs, record, onUpdate, onUpdateNew } = this.props
    const { uuid, weight } = this.state

    const uuid_ = uuid.or(uuidv4())
    this.setState({ uuid: Option.Some(uuid_) })

    if (inp.isSome()) {
      if (record.isSome()) {
        this.props.onUpdate(
          new types.Record(
            record.unwrap().id,
            record.unwrap().data.withWeight(inp.unwrap()),
          ),
        )
      } else {
        this.props.onUpdateNew(
          uuid_,
          new types.WeightRecord(
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
      <div className="weight">
        <ValidatedInputField
          value={record.map(r => r.data.weight)}
          placeholder={i18n.WeightEntryPlaceholder.tr(prefs.language)}
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
          onChange={this.onChange}
        />
        <div> {prefs.units.massRepr.tr(prefs.language)} </div>
      </div>
    )
  }
}
