import React from 'react';
import { connect } from 'react-redux'

import { runAuthentication } from '../state/actions'


class LoginForm extends React.Component {
    constructor (props) {
        super(props)

        this.state = { token: null };
    }

    render () {
        return <div className="container-fluid">
                    <div className="row" style={{paddingTop: "80px"}}>
                        <div className="col-sm-2"> </div>
                        <div className="col-sm-8" style={{textAlign: "center"}}>
                        <h1> Health Tracker </h1>
                        <p> <input type="text" style={{"width": "100%"}} onChange={(ev) => this.setState({'token': ev.target.value})} placeholder="Enter your login token" /> </p>
                        <p> <button type="button" className="btn btn-outline-primary" onClick={(ev) => this.props.onSubmit(this.state)}>Log In</button> </p>
                        </div>
                        <div className="col-sm-2"> </div>
                    </div>
               </div>
    }
}

const mapStateToProps = state => ({})
const mapDispatchToProps = dispatch => ({ onSubmit: (st) => dispatch(runAuthentication(st.token)) })

export const LoginView = connect(mapStateToProps, mapDispatchToProps)(LoginForm)

