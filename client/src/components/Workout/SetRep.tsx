import { Option, Result } from "ld-ambiguity"
import _ from "lodash/fp"
import * as luxon from "luxon"
import React, { useState } from "react"
import Select from "react-select"

import { classnames, ClassNames } from "../../classnames"
import { Date, DateTimeTz } from "../../datetimetz"
import * as i18n from "../../i18n"
import { parseTime } from "../../parsers"
import { UserPreferences } from "../../settings"
import * as types from "../../types"
import { SetsView, SetsEdit } from "../Sets"
import ValidatedInputField from "../ValidatedInputField"

interface ViewProps {
  prefs: UserPreferences
  record: types.Record<types.SetRepRecord>
}

export const SetRepRecordView: React.SFC<ViewProps> = ({ prefs, record }) => (
  <div className="setrep-view l-3-column">
    <div className="activity">
      {record.data.activity.repr.tr(prefs.language)}
    </div>
    <div className="sets">
      <SetsView sets={record.data.sets} />
    </div>
  </div>
)

interface EditProps {
  prefs: UserPreferences
  uuid: Option<string>
  record: types.SetRepRecord
  save: (
    uuid: Option<string>,
    data: types.RecordTypes,
  ) => Promise<Result<null, string>>
  cancel: () => void
}

export const SetRepRecordEdit: React.SFC<EditProps> = ({
  prefs,
  uuid,
  record,
  save,
  cancel,
}) => {
  const [activity, setActivity] = useState(record.activity)
  const [sets, setSets] = useState(record.sets)

  const onSave = () => {
    save(uuid, new types.SetRepRecord(record.date, activity, sets)).then(
      result => (result.isOk() ? cancel() : null),
    )
  }

  return (
    <div className="setrep-edit l-3-column">
      <div className="activity">
        <Select
          style={{ width: "100%" }}
          name="activity-selection"
          defaultValue={{
            label: activity.repr.tr(prefs.language),
            value: activity,
          }}
          options={_.map((activity: types.SetRepActivity): {
            value: types.SetRepActivity
            label: string
          } => ({
            value: activity,
            label: activity.repr.tr(prefs.language),
          }))([types.Pushups, types.Situps])}
          onChange={(inp: any) => setActivity(inp.value)}
        />
      </div>
      <div className="sets">
        <SetsEdit
          sets={record.sets}
          onChange={inp => setSets(inp.unwrap())}
          prefs={prefs}
        />
      </div>
      <div>
        <button onClick={onSave}>{i18n.Save.tr(prefs.language)}</button>
        <button onClick={cancel}>{i18n.Cancel.tr(prefs.language)}</button>
      </div>
    </div>
  )
}

interface Props {
  prefs: UserPreferences
  record: types.Record<types.SetRepRecord>
  save: (
    uuid: Option<string>,
    data: types.RecordTypes,
  ) => Promise<Result<null, string>>
}

const SetRepRecordComponent: React.SFC<Props> = ({ prefs, record, save }) => {
  const [editing, setEditing] = useState(false)

  return editing ? (
    <SetRepRecordEdit
      prefs={prefs}
      uuid={Option.Some(record.id)}
      record={record.data}
      save={save}
      cancel={() => setEditing(false)}
    />
  ) : (
    <div onClick={() => setEditing(true)}>
      <SetRepRecordView prefs={prefs} record={record} />
    </div>
  )
}

export default SetRepRecordComponent
