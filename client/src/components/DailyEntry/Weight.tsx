import math from "mathjs"
import React from "react"
import { classnames, ClassNames } from "../../classnames"

import uuidv4 from "uuid/v4"
import ValidatedInputField from "../ValidatedInputField"
import Option from "../../option"
import * as msgs from "../../translations"
import * as types from "../../types"
import { UserPreferences } from "../../userPrefs"
import { DateTimeTz, Date } from "../../datetimetz"

interface ViewProps {
  prefs: UserPreferences
  record: types.Record<types.WeightRecord>
}

export const WeightRecordView: React.SFC<ViewProps> = ({ prefs, record }) => (
  <div className="record weight">
    <div>
      {record.data.weight
        .to(prefs.units.mass)
        .format({ notation: "fixed", precision: 2 })}
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

  onChange = (inp: math.Unit) => {
    const { date, prefs, record, onUpdate, onUpdateNew } = this.props
    const { uuid, weight } = this.state

    const uuid_ = uuid.or(uuidv4())
    this.setState({ uuid: Option.Some(uuid_) })

    record.mapOrElse(
      r => this.props.onUpdate(new types.Record(r.id, r.data.withWeight(inp))),
      () => {
        console.log("or_else dispatching")
        this.props.onUpdateNew(
          uuid_,
          new types.WeightRecord(
            DateTimeTz.fromDate(date, prefs.timezone),
            inp,
          ),
        )
      },
    )
  }

  render() {
    const { date, prefs, record } = this.props
    console.log("rendering", record)
    return (
      <div className="flex">
        <ValidatedInputField
          value={record.map(r => r.data.weight)}
          placeholder={msgs.WeightEntryPlaceholder.tr(prefs.language)}
          render={(val: math.Unit): string =>
            math.format(val.toNumber(prefs.units.mass), {
              notation: "fixed",
              precision: 2,
            })
          }
          parse={(inp: string): Option<math.Unit> => {
            const val = parseFloat(inp)
            if (val !== NaN) {
              const newWeight = math.unit(val, this.props.prefs.units.mass)
              return Option.Some(newWeight)
            }
            return Option.None()
          }}
          onChange={this.onChange}
        />
        <div> {prefs.units.massRepr.tr(prefs.language)} </div>
      </div>
    )
  }
}
