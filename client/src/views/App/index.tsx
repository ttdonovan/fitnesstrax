import React from "react"
import { connect } from "react-redux"

import Controller from "../../controller"
import * as redux from "../../redux"
import HomeView from "../Home"
import LoginView from "../Login"

interface Props {
  controller: Controller
  creds: string | null
}

const App: React.SFC<Props> = ({ controller, creds }: Props) =>
  creds ? <HomeView /> : <LoginView controller={controller} token={null} />

const AppView = connect((state: redux.AppState) => ({
  creds: redux.getCredentials(state),
}))(App)

export default AppView
