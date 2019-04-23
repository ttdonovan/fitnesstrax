import React from "react"
import { connect } from "react-redux"

import { runAuthentication } from "../state/actions"
import InputField from "./InputField"

export interface Props {
  token: string | null
  onSubmit: (_: { token: string }) => void
}

class State {
  token: string | null = null
}

export class LoginForm extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props)
    this.state = { token: props.token }
  }

  render() {
    const { onSubmit } = this.props
    const { token } = this.state

    return (
      <div id="LoginForm" className="container-fluid">
        <div className="row" style={{ paddingTop: "80px" }}>
          <div className="col-sm-2"> </div>
          <div className="col-sm-8" style={{ textAlign: "center" }}>
            <h1> Health Tracker </h1>
            <p>
              <InputField
                value={token}
                classNames={[]}
                onChange={val => this.setState({ token: val.value })}
              />
            </p>
            <p>
              <button
                name="LoginButton"
                type="button"
                className="btn btn-outline-primary"
                onClick={ev => token && onSubmit({ token })}
              >
                Log In
              </button>
            </p>
          </div>
          <div className="col-sm-2"> </div>
        </div>
      </div>
    )
  }
}

const mapStateToProps = (state: any) => ({})
const mapDispatchToProps = (dispatch: any) => ({
  onSubmit: (st: State) => dispatch(runAuthentication(st.token)),
})

export const LoginView = connect(
  mapStateToProps,
  mapDispatchToProps,
)(LoginForm)
