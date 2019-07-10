import { Option } from "ld-ambiguity"
import { IANAZone } from "luxon"
import React from "react"
import { connect } from "react-redux"

import CenterPanel from "../../components/CenterPanel"
import Error from "../../components/Error"
import Navigation from "../../components/Navigation"
import Controller from "../../controller"
import { DateTimeTz } from "../../datetimetz"
import * as redux from "../../redux"
import { UserPreferences } from "../../settings"
import { Range } from "../../types"
import HistoryView from "../History"
import LoginView from "../Login"
import UserPreferencesView from "../UserPrefs"

interface Props {
  controller: Controller
  creds: string | null
  error: string | null
  prefs: UserPreferences
  view: redux.Views
  setView: (_: redux.Views) => void
}

const App: React.SFC<Props> = ({
  controller,
  creds,
  error,
  prefs,
  view,
  setView,
}: Props) => (
  <div>
    {error ? <Error msg={error} /> : null}
    {creds ? (
      <React.Fragment>
        <div className="header">
          <div className="logo">Fitnesstrax</div>
          <Navigation prefs={prefs} view={view} setView={setView} />
        </div>
        <CenterPanel>
          <div>
            {view === "History" ? (
              <HistoryView controller={controller} />
            ) : (
              <UserPreferencesView
                prefs={prefs}
                onSave={controller.setPreferences}
              />
            )}
          </div>
        </CenterPanel>
      </React.Fragment>
    ) : (
      <LoginView controller={controller} prefs={prefs} token={Option.None()} />
    )}
  </div>
)

const AppView = connect(
  (state: redux.AppState) => ({
    creds: redux.getAuthToken(state),
    error: redux.getError(state),
    prefs: redux.getPreferences(state),
    view: redux.getCurrentView(state),
  }),
  dispatch => ({
    setView: (view: redux.Views) => dispatch(redux.setView(view)),
  }),
)(App)

export default AppView
