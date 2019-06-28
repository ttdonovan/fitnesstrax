import { Option } from "ld-ambiguity"
import { IANAZone } from "luxon"
import React from "react"
import { connect } from "react-redux"

import CenterPanel from "../../components/CenterPanel"
import Navigation from "../../components/Navigation"
import Controller from "../../controller"
import DateTimeTz from "../../datetimetz"
import * as redux from "../../redux"
import { UserPreferences } from "../../settings"
import HistoryView from "../History"
import LoginView from "../Login"
import UserPreferencesView from "../UserPrefs"

interface Props {
  controller: Controller
  creds: string | null
  prefs: UserPreferences
  view: redux.Views
  setView: (_: redux.Views) => void
}

const App: React.SFC<Props> = ({
  controller,
  creds,
  prefs,
  view,
  setView,
}: Props) =>
  creds ? (
    <CenterPanel>
      <div>
        <Navigation
          classes={{ "l-navigation": true }}
          prefs={prefs}
          view={view}
          setView={setView}
        />
        {view === "History" ? (
          <HistoryView
            controller={controller}
            range={{
              start: DateTimeTz.fromString("2017-10-27T00:00:00Z").unwrap(),
              end: DateTimeTz.fromString("2018-01-01T00:00:00Z").unwrap(),
            }}
          />
        ) : (
          <UserPreferencesView
            prefs={prefs}
            onSave={controller.setPreferences}
          />
        )}
      </div>
    </CenterPanel>
  ) : (
    <LoginView controller={controller} prefs={prefs} token={Option.None()} />
  )

const AppView = connect(
  (state: redux.AppState) => ({
    creds: redux.getAuthToken(state),
    prefs: redux.getPreferences(state),
    view: redux.getCurrentView(state),
  }),
  dispatch => ({
    setView: (view: redux.Views) => dispatch(redux.setView(view)),
  }),
)(App)

export default AppView
