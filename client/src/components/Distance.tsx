import { Option, Result } from "ld-ambiguity"
import * as math from "mathjs"
import React from "react"

import * as i18n from "../i18n"
import { parseNumber } from "../parsers"
import { UnitSystem, UserPreferences } from "../settings"
import ValidatedInputField from "./ValidatedInputField"

const renderDistance = (
  d: math.Unit,
  units: UnitSystem,
  language: i18n.Language,
) =>
  `${math.format(d.toNumber(units.length), {
    notation: "fixed",
    precision: 2,
  })} ${units.lengthRepr.tr(language)}`

interface ViewProps {
  distance: math.Unit
  prefs: UserPreferences
}

export const DistanceView: React.SFC<ViewProps> = ({ distance, prefs }) => (
  <React.Fragment>
    {renderDistance(distance, prefs.units, prefs.language)}
  </React.Fragment>
)

interface EditProps {
  distance: Option<math.Unit>
  onChange: (_: Option<math.Unit>) => void
  prefs: UserPreferences
}

export const DistanceEdit: React.SFC<EditProps> = ({
  distance,
  onChange,
  prefs,
}) => (
  <React.Fragment>
    <ValidatedInputField
      value={distance}
      placeholder={i18n.DistanceEntryPlaceholder.tr(prefs.language)}
      render={d =>
        math.format(d.toNumber(prefs.units.length), {
          notation: "fixed",
          precision: 2,
        })
      }
      parse={str => {
        if (str === "") return Result.Ok(Option.None())
        return parseNumber(str).map(n =>
          n.map(n_ => math.unit(n_, prefs.units.length)),
        )
      }}
      onChange={inp => onChange(inp)}
    />
    {prefs.units.length}
  </React.Fragment>
)

export default DistanceView
