import React from "react"
import { classnames, ClassNames } from "../../classnames"

import * as types from "../../types"
import { UserPreferences } from "../../userPrefs"

interface Props {
  prefs: UserPreferences
  record: types.WeightRecord
}

const WeightRecord: React.SFC<Props> = ({ prefs, record }) => {
  console.log(prefs.units)
  return (
    <div className="record weight">
      <div>
        {record.weight
          .to(prefs.units.mass)
          .format({ notation: "fixed", precision: 2 })}
      </div>
    </div>
  )
}

export default WeightRecord
