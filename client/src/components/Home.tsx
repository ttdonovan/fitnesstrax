import React from "react"
import { connect } from "react-redux"

import { runLogout } from "../state/actions"

import { CalendarView } from "./Calendar"
import { HistoryView } from "./HistoryView"
import { LoginView } from "./LoginForm"
import { NewDay } from "./NewDay"
import { SummaryView } from "./Summary"

export const Home = ({ onLogout }: { onLogout: () => void }) => (
  <div className="container-fluid">
    <div className="row">
      <nav className="navbar fixed-top navbar-toggleable-sm navbar-light bg-faded">
        <div className="collapse navbar-collapse" id="navbarNav">
          <ul className="navbar-nav mr-auto">
            <li className="nav-item active">
              <a className="nav-link" href="#">
                History <span className="sr-only">(current)</span>
              </a>
            </li>
            <li className="nav-item">
              <a className="nav-link" href="#">
                Charts
              </a>
            </li>
          </ul>
          <div className="form-inline mr-2">
            <button type="button" className="btn" onClick={ev => onLogout()}>
              Log out
            </button>
          </div>
        </div>
      </nav>
    </div>
    <div className="row" style={{ paddingTop: "80px" }}>
      <div className="col-sm-4">
        <SummaryView />
        <CalendarView />
      </div>
      <div className="col-sm-8">
        <HistoryView />
      </div>
    </div>
  </div>
)

export const HomeView = connect(
  () => ({}),
  dispatch => ({ onLogout: () => dispatch(runLogout()) }),
)(Home)
