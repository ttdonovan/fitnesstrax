import React from "react"
import Calendar from "react-calendar"

import * as csn from "../../classnames"
import * as dtz from "../../datetimetz"
import { UserPreferences } from "../../settings"
import Icon from "../Icon"
import "./style.css"

const toJSDate = (d: dtz.Date) => new Date(d.year, d.month - 1, d.day)
const fromJSDate = (d: Date): dtz.Date =>
  new dtz.Date(d.getFullYear(), d.getMonth() + 1, d.getDate())

interface Props {
  date: dtz.Date
  prefs: UserPreferences
  setBound: (d: dtz.Date) => void
}

interface State {
  calendarVisible: boolean
}

class DatePicker extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props)
    this.state = { calendarVisible: false }
  }

  render() {
    const { date, prefs, setBound } = this.props

    return (
      <div className="date-field">
        <div
          className="date"
          onClick={() =>
            this.setState({ calendarVisible: !this.state.calendarVisible })
          }
        >
          <Icon path="/static/calendar_icon.png" />
          {this.props.date.toString()}
        </div>
        <Calendar
          className={csn.classnames({
            calendar: true,
            invisible: !this.state.calendarVisible,
          })}
          locale={prefs.language.sym}
          value={toJSDate(date)}
          onChange={(d: Date) => {
            this.setState({ calendarVisible: false })
            setBound(fromJSDate(d))
          }}
        />
      </div>
    )
  }
}

export default DatePicker

// https://icons8.com/
