import React from "react"
import { connect } from "react-redux"

import { classnames, ClassNames } from "../../classnames"
import * as redux from "../../redux"
import * as msgs from "../../translations"
import { UserPreferences } from "../../userPrefs"

interface Props {
  classes?: ClassNames
  prefs: UserPreferences
  view: redux.Views
  setView: (_: redux.Views) => void
}

const Navigation: React.SFC<Props> = ({
  classes,
  prefs,
  view,
  setView,
}: Props) => (
  <div className={classnames({ navigation: true, ...classes })}>
    <div>
      <a onClick={() => setView("History")}>
        {msgs.History.tr(prefs.language)}
      </a>
    </div>
    <div>
      <a onClick={() => setView("Preferences")}>
        {msgs.Preferences.tr(prefs.language)}
      </a>
    </div>
  </div>
)

export default Navigation
