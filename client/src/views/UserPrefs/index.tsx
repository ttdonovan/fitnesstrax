import React from "react"
import Select from "react-select"
import _ from "lodash/fp"
import moment from "moment-timezone"
import { IANAZone } from "luxon"

import { Language, Languages, languageFromSymbol } from "../../i18n"
import {
  UserPreferences,
  UnitSystem,
  UnitSystems,
  unitsystemFromSymbol,
} from "../../settings"

interface Props {
  prefs: UserPreferences
  onSave: (_: UserPreferences) => void
}

const UserPreferenceView: React.SFC<Props> = ({ prefs, onSave }: Props) => (
  <div id="UserPreferences">
    <div className="l-2-column">
      <div> TimeZone </div>
      <div>
        <Select
          name="timezone-selection"
          defaultValue={{
            value: prefs.timezone.name,
            label: prefs.timezone.name,
          }}
          options={_.map((tzname: string) => ({
            value: tzname,
            label: tzname,
          }))(moment.tz.names())}
          onChange={(evt: any) =>
            onSave(prefs.withTimezone(IANAZone.create(evt.value)))
          }
        />
      </div>
    </div>
    <div className="l-2-column">
      <div> Language </div>
      <div>
        <Select
          name="language-selection"
          defaultValue={{
            value: prefs.language.sym,
            label: prefs.language.name,
          }}
          options={_.map((v: Language) => ({ value: v.sym, label: v.name }))(
            Languages,
          )}
          onChange={(evt: any) =>
            onSave(prefs.withLanguage(languageFromSymbol(evt.value).unwrap()))
          }
        />
      </div>
    </div>
    <div className="l-2-column">
      <div> Units </div>
      <div>
        <Select
          name="units-selection"
          defaultValue={{
            value: prefs.units.sym,
            label: prefs.units.sym,
          }}
          options={_.map((v: UnitSystem) => ({ value: v.sym, label: v.sym }))(
            UnitSystems,
          )}
          onChange={(evt: any) =>
            onSave(prefs.withUnits(unitsystemFromSymbol(evt.value).unwrap()))
          }
        />
      </div>
    </div>
  </div>
)

export default UserPreferenceView
