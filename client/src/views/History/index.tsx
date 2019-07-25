import { Option } from "ld-ambiguity"
import _ from "lodash/fp"
import moment from "moment-timezone"
import React from "react"
import { connect } from "react-redux"

import RangeView from "../../components/range"
import DailyEntryView from "../../components/DailyEntry"
import Controller from "../../controller"
import * as redux from "../../redux"
import { UserPreferences } from "../../settings"
import { daysInRange, Range, Record, RecordTypes } from "../../types"
import { DateTimeTz, Date } from "../../datetimetz"

interface Props {
  controller: Controller
  history: Array<Record<RecordTypes>>
  prefs: UserPreferences
  range: Range<Date>
}

class History extends React.Component<Props, {}> {
  componentDidMount() {
    const { range } = this.props
    const start = DateTimeTz.fromDate(range.start, this.props.prefs.timezone)
    const end = DateTimeTz.fromDate(range.end, this.props.prefs.timezone).plus({
      days: 1,
    })
    const requestRange = new Range(start, end)
    this.props.controller.fetchRecords(requestRange)
  }

  render() {
    const { controller, history, prefs, range } = this.props

    return (
      <div id="History">
        {_.map((date: Date) => (
          <DailyEntryView
            key={date.toString()}
            date={date}
            prefs={prefs}
            records={_.filter((rec: Record<RecordTypes>) =>
              rec.data.date.toHaveDate(date),
            )(history)}
            saveRecords={records => this.props.controller.saveRecords(records)}
          />
        ))(
          _.reverse(
            daysInRange(range.map(d => DateTimeTz.fromDate(d, prefs.timezone))),
          ),
        )}
      </div>
    )
  }
}

const HistoryView = connect((state: redux.AppState) => ({
  prefs: redux.getPreferences(state),
  history: redux.getHistory(state),
  range: redux.getRange(state),
}))(History)

export default HistoryView
