import * as math from "mathjs"
import React from "react"

import { UserPreferences } from "../settings"

interface Props {
  weight: math.Unit
  prefs: UserPreferences
}

const Weight: React.SFC<Props> = ({ weight, prefs }) => (
  <span>
    {math.format(weight.toNumber(prefs.units.mass), {
      notation: "fixed",
      precision: 2,
    })}
    {prefs.units.massRepr.tr(prefs.language)}
  </span>
)

export default Weight
