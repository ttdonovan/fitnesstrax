import math from "mathjs"
import React from "react"
import { classnames, ClassNames } from "../../classnames"

import ValidatedInputField from "../ValidatedInputField"
import Option from "../../option"
import * as msgs from "../../translations"
import * as types from "../../types"
import { UserPreferences } from "../../userPrefs"

interface ViewProps {
  prefs: UserPreferences
  record: types.WeightRecord
}

export const WeightRecordView: React.SFC<ViewProps> = ({ prefs, record }) => (
  <div className="record weight">
    <div>
      {record.weight
        .to(prefs.units.mass)
        .format({ notation: "fixed", precision: 2 })}
    </div>
  </div>
)

interface EditProps {
  prefs: UserPreferences
  record: Option<types.WeightRecord>
  onUpdate: (uuid: string, record: types.Record) => void
}

interface State {
  weight: Option<math.Unit>
}

interface Event {
  value: string
}

export class WeightRecordEdit extends React.Component<EditProps, State> {
  constructor(props: EditProps) {
    super(props)
    this.state = { weight: this.props.record.map(w => w.weight) }
  }

  onUpdate(evt: any) {
    console.log(evt)
    const val = parseFloat(evt.value)
    const newWeight = math.unit(val, this.props.prefs.units.mass)
    /* Going to need the current date in order to be able to create a new
         * record. Might also need a special function for creating new records
         * since IDs get assigned by the database. */
    this.setState({ weight: Option.Some(newWeight) })
    this.props.onUpdate(
      this.props.record.unwrap().id,
      this.props.record.unwrap().withWeight(newWeight),
    )
  }

  render() {
    const { prefs, record, onUpdate } = this.props
    return (
      <div className="flex">
        <ValidatedInputField
          value={this.state.weight}
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
          onChange={(inp: math.Unit) =>
            this.props.onUpdate(
              record.unwrap().id,
              this.props.record.unwrap().withWeight(inp),
            )
          }
        />
        <div> {prefs.units.massRepr.tr(prefs.language)} </div>
      </div>
    )
  }
}
