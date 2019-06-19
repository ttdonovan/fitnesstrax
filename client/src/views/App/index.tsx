import React from "react"
import { connect } from "react-redux"
import { IANAZone } from "luxon"

import CenterPanel from "../../components/CenterPanel"
import Navigation from "../../components/Navigation"
import Controller from "../../controller"
import DateTimeTz from "../../datetimetz"
import * as redux from "../../redux"
import HistoryView from "../History"
import LoginView from "../Login"

interface Props {
  controller: Controller
  creds: string | null
  view: redux.Views
  setView: (_: redux.Views) => void
}

const App: React.SFC<Props> = ({ controller, creds, view, setView }: Props) =>
  creds ? (
    <CenterPanel>
      <div>
        <Navigation
          classes={{ "l-navigation": true }}
          view={view}
          setView={setView}
        />
        <HistoryView
          controller={controller}
          range={{
            start: DateTimeTz.fromString("2017-10-27T00:00:00Z").unwrap(),
            end: DateTimeTz.fromString("2018-01-01T00:00:00Z").unwrap(),
          }}
        />
      </div>
    </CenterPanel>
  ) : (
    <LoginView controller={controller} token={null} />
  )

const AppView = connect(
  (state: redux.AppState) => ({
    creds: redux.getAuthToken(state),
    view: redux.getCurrentView(state),
  }),
  dispatch => ({
    setView: (view: redux.Views) => dispatch(redux.setView(view)),
  }),
)(App)

export default AppView
