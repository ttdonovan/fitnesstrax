import React from "react"
import { connect } from "react-redux"

//import { authenticate } from "../state"
import Controller from "../../controller"
import InputField from "../../components/InputField"
import * as msgs from "../../translations"
import { UserPreferences } from "../../userPrefs"

export interface Props {
  controller: Controller
  prefs: UserPreferences
  token: string | null
  //onSubmit: (_: { token: string }) => void
}

class State {
  token: string | null = null
}

class Login extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props)
    this.state = { token: props.token }
  }

  render() {
    const { controller, prefs } = this.props
    const { token } = this.state

    return (
      <div id="LoginForm" className="container-fluid">
        <div className="row" style={{ paddingTop: "80px" }}>
          <div className="col-sm-2"> </div>
          <div className="col-sm-8" style={{ textAlign: "center" }}>
            <h1> {msgs.HealthTracker.tr(prefs.language)}</h1>
            <p>
              <InputField
                value={token}
                onChange={val => this.setState({ token: val.value })}
                placeholder={msgs.LoginPlaceholder.tr(prefs.language)}
              />
            </p>
            <p>
              <button
                name="LoginButton"
                type="button"
                className="btn btn-outline-primary"
                onClick={ev => token && controller.authenticate(token)}
              >
                {msgs.LogIn.tr(prefs.language)}
              </button>
            </p>
          </div>
          <div className="col-sm-2"> </div>
        </div>
      </div>
    )
  }
}

export default Login
