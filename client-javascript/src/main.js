import React from 'react'
import ReactDOM from 'react-dom'
import math from 'mathjs'
import moment from 'moment'
import thunkMiddleware from 'redux-thunk'
import { connect, Provider } from 'react-redux'
import { createLogger } from 'redux-logger'
import { createStore, applyMiddleware } from 'redux'
import PropTypes from 'prop-types'

import { getCredentials } from './state/state'
import { handleAction } from './state/reducers'
import { isSomething } from './common'

import { HomeView } from './components/Home'
import { LoginView } from './components/LoginForm'

/*
 * Knowing very little about the application structure thus far...
 *
 * application states:
 *  If there is no authentication information, we need to find out the login server and go talk to it. Provide a form for entering the username and password and talking directly to the server. The server should provide back a valid token.
 *  If there is authentication information, just talk directly to the server. Start by asking for default data.
 *
 * not logged in
 * logged in, no data
 * data available
 * submit data to server
 *
 * Each widget may have its own internal state. See if the built-in widgets handle that well, and use them if so. Otherwise, encapsulate them in widgets that do handle internal state. For instance, editing a widget should cause an update to the data stored in memory, not just what is visible in the widget. Also, validators.
 *
 * Needed:
 *  Summary Box
 *  History Box
 *  History Entry
 *  Weight edit field
 *  Time/Distance edit field
 *  Set/Rep edit field
 *  Edit widget with validator
 */

class App extends React.Component {
    render () {
        console.log(this)
        if (isSomething(this.props.creds)) {
            return <HomeView />
        } else {
            return <LoginView />
        }
    }
}

const AppView = connect( (state) => ({ creds: getCredentials(state) })
                       , (dispatch) => ({ })
                       )(App)


const main = function main () {
    const store = createStore(handleAction, applyMiddleware(thunkMiddleware, createLogger()))
    window.moment = moment
    window.math = math
    /* TODO: next, create some store operations that get the credentials from local storage */
    ReactDOM.render(<Provider store={store}><AppView /></Provider>, document.getElementById('root'));
}


main();

