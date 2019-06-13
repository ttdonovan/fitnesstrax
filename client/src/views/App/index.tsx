import React from "react"
import { connect } from "react-redux"

import Controller from "../../controller"
import DateTimeTz from "../../datetimetz"
import * as redux from "../../redux"
//import HomeView from "../Home"
import HistoryView from "../History"
import LoginView from "../Login"

interface Props {
  controller: Controller
  creds: string | null
}

const App: React.SFC<Props> = ({ controller, creds }: Props) =>
  creds ? (
    <HistoryView
      controller={controller}
      range={{
        start: DateTimeTz.fromString("2017-10-27T00:00:00Z").unwrap(),
        end: DateTimeTz.fromString("2018-01-01T00:00:00Z").unwrap(),
      }}
    />
  ) : (
    <LoginView controller={controller} token={null} />
  )

const AppView = connect((state: redux.AppState) => ({
  creds: redux.getAuthToken(state),
}))(App)

export default AppView
