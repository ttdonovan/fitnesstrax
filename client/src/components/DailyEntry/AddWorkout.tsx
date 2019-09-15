import _ from "lodash/fp"
import React from "react"
import Select from "react-select"

import * as i18n from "../../i18n"
import { UserPreferences } from "../../settings"
import * as types from "../../types"

interface Props {
  prefs: UserPreferences
  onSelect: (value: any) => void
}

const AddWorkout: React.SFC<Props> = ({ prefs, onSelect }: Props) => (
  <div className="add-workout">
    <Select
      style={{ width: "100%" }}
      name="activity-selection"
      placeholder={i18n.AddWorkout.tr(prefs.language)}
      options={_.map((activity: any) => ({
        value: activity,
        label: activity.repr.tr(prefs.language),
      }))([types.Cycling, types.Running, types.Swimming, types.Walking])}
      onChange={onSelect}
    />
  </div>
)

export default AddWorkout
