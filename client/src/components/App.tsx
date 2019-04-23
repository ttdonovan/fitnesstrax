import React from "react"
import { connect } from "react-redux"

import { getCredentials, AppState } from "../state"
import { HomeView } from "./Home"
import { LoginView } from "./LoginForm"

export const App = ({ creds }: { creds: string | null }) =>
  creds ? <HomeView /> : <LoginView token={null} />

const AppView = connect(
  (state: AppState) => ({ creds: getCredentials(state) }),
  dispatch => ({}),
)(App)

export default AppView
