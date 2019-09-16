import { Option, Result } from "ld-ambiguity"
import _ from "lodash/fp"
import React from "react"

import { classnames, ClassNames } from "../../classnames"
import { UserPreferences } from "../../settings"
import * as types from "../../types"
import SetRepRecordComponent, { SetRepRecordEdit } from "./SetRep"
import TimeDistanceRecordComponent, {
  TimeDistanceRecordEdit,
} from "./TimeDistance"

import "./style.css"

interface WorkoutProps {
  prefs: UserPreferences
  record: types.Record<types.RecordTypes>
  save: (
    uuid: Option<string>,
    data: types.RecordTypes,
  ) => Promise<Result<null, string>>
}

export const Workout: React.SFC<WorkoutProps> = ({ prefs, record, save }) => {
  console.log(JSON.stringify(record.data))
  if (types.isTimeDistanceRecord(record.data)) {
    return (
      <TimeDistanceRecordComponent
        prefs={prefs}
        record={record as types.Record<types.TimeDistanceRecord>}
        save={save}
      />
    )
  } else if (types.isSetRepRecord(record.data)) {
    return (
      <SetRepRecordComponent
        prefs={prefs}
        record={record as types.Record<types.SetRepRecord>}
        save={save}
      />
    )
  } else return null
}

interface NewWorkoutProps {
  prefs: UserPreferences
  record: types.RecordTypes
  save: (
    uuid: Option<string>,
    data: types.RecordTypes,
  ) => Promise<Result<null, string>>
  cancel: () => void
}

export const NewWorkout: React.SFC<NewWorkoutProps> = ({
  prefs,
  record,
  save,
  cancel,
}) => {
  if (types.isTimeDistanceRecord(record)) {
    return (
      <TimeDistanceRecordEdit
        prefs={prefs}
        uuid={Option.None()}
        record={record}
        save={save}
        cancel={cancel}
      />
    )
  } else if (types.isSetRepRecord(record)) {
    return (
      <SetRepRecordEdit
        prefs={prefs}
        uuid={Option.None()}
        record={record}
        save={save}
        cancel={cancel}
      />
    )
  } else return null
}
