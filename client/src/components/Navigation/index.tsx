import React from "react"
import { connect } from "react-redux"

import { classnames, ClassNames } from "../../classnames"
import * as redux from "../../redux"
import * as msgs from "../../translations"

interface Props {
  classes?: ClassNames
  view: redux.Views
  setView: (_: redux.Views) => void
}

const Navigation: React.SFC<Props> = ({ classes, view, setView }: Props) => (
  <div className={classnames({ navigation: true, ...classes })}>
    <div>
      <a onClick={() => setView("History")}>
        {msgs.History.tr(msgs.Language.Esperanto)}
      </a>
    </div>
    <div>
      <a onClick={() => setView("Preferences")}>
        {msgs.Preferences.tr(msgs.Language.Esperanto)}
      </a>
    </div>
  </div>
)

export default Navigation
