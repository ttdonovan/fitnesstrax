import React from "react"
import { connect } from "react-redux"

import { classnames, ClassNames } from "../../classnames"
import * as redux from "../../redux"
import * as i18n from "../../i18n"
import { UserPreferences } from "../../settings"

import "./style.css"

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
  <div
    className={classnames({
      navigation: true,
      ...classes,
    })}
  >
    <div className={classnames({ current: view === "History" })}>
      <a onClick={() => setView("History")}>
        {i18n.History.tr(prefs.language)}
      </a>
    </div>
    <div className={classnames({ current: view === "Preferences" })}>
      <a onClick={() => setView("Preferences")}>
        {i18n.Preferences.tr(prefs.language)}
      </a>
    </div>
  </div>
)

export default Navigation
