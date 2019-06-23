import math from "mathjs"
import React from "react"
import { classnames, ClassNames } from "../../classnames"

import InputField from "../InputField"
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
}

export const WeightRecordEdit: React.SFC<EditProps> = ({ prefs, record }) => (
  <div className="flex">
    <InputField
      value={record
        .map(
          (wr: types.WeightRecord): string =>
            math.format(wr.weight.toNumber(prefs.units.mass), {
              notation: "fixed",
              precision: 2,
            }),
        )
        .or("")}
      onChange={() => null}
      placeholder={msgs.WeightEntryPlaceholder.tr(prefs.language)}
    />
    <div> {prefs.units.massRepr.tr(prefs.language)} </div>
  </div>
)
