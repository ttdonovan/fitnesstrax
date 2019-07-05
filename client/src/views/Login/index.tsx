import { Option } from "ld-ambiguity"
import React from "react"
import { connect } from "react-redux"

//import { authenticate } from "../state"
import Controller from "../../controller"
import InputField from "../../components/InputField"
import * as i18n from "../../i18n"
import { UserPreferences } from "../../settings"

export interface Props {
  controller: Controller
  prefs: UserPreferences
  token: Option<string>
  //onSubmit: (_: { token: string }) => void
}

interface State {
  token: Option<string>
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
            <h1> {i18n.HealthTracker.tr(prefs.language)}</h1>
            <p>
              <InputField
                value={token.or("")}
                onChange={val => this.setState({ token: Option.Some(val) })}
                placeholder={i18n.LoginPlaceholder.tr(prefs.language)}
              />
            </p>
            <p>
              <button
                name="LoginButton"
                type="button"
                className="btn btn-outline-primary"
                onClick={ev => token.map(t => controller.authenticate(t))}
              >
                {i18n.LogIn.tr(prefs.language)}
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
