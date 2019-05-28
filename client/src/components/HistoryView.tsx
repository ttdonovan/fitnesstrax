import React from "react"
import moment from "moment"
import { connect } from "react-redux"

//import { HistoryEntry } from "../types"
import { isSomething } from "../common"
//import { runFetchHistory } from "../state/actions"
import { getCurrentlyEditing, getHistory, getRange } from "../state/state"

import { DailyEntryView, DailyEntryEditView } from "./DailyEntry"

export interface Props {
  //fetchData: () => void
  history: any
  range: any
  currentEdit: any
}

class History extends React.Component<Props, object> {
  /*
  componentDidMount() {
    this.props.fetchData()
  }
  */

  render() {
    return <div />
    /*
    if (isSomething(this.props.history)) {
      const today = moment({ hour: 0, minute: 0, second: 0 })
      const [start, end] = isSomething(this.props.range)
        ? this.props.range
        : [this.props.history.startRange(), today]
      const days = fillInDayRange(start, end).reverse()
      return (
        <div>
          {days.map(date => {
            var entry = this.props.history.entry(date)
            if (
              isSomething(entry) &&
              isSomething(this.props.currentEdit) &&
              this.props.currentEdit.isSame(entry.date)
            ) {
              return <DailyEntryEditView date={date} data={entry} />
            } else if (
              isSomething(entry) &&
              isSomething(this.props.currentEdit) &&
              !this.props.currentEdit.isSame(entry.date)
            ) {
              return <DailyEntryView date={date} data={entry} />
            } else if (
              isSomething(entry) &&
              !isSomething(this.props.currentEdit)
            ) {
              return <DailyEntryView date={date} data={entry} />
            } else if (
              !isSomething(entry) &&
              isSomething(this.props.currentEdit) &&
              this.props.currentEdit.isSame(date)
            ) {
              return <DailyEntryEditView date={date} data={entry} />
            } else if (
              !isSomething(entry) &&
              isSomething(this.props.currentEdit) &&
              !this.props.currentEdit.isSame(date)
            ) {
              return (
                <DailyEntryView
                  date={date}
                  data={{ weightRecord: null, timeDistanceRecords: [] }}
                />
              )
            } else if (
              !isSomething(entry) &&
              !isSomething(this.props.currentEdit)
            ) {
              return (
                <DailyEntryView
                  date={date}
                  data={{ weightRecord: null, timeDistanceRecords: [] }}
                />
              )
            } else {
              throw new Error(
                `Unhandled case in History.render: ${entry}, ${
                  this.props.currentEdit
                }`,
              )
            }
          })}{" "}
        </div>
      )
    } else {
      return null
    }
    */
  }
}

/* *ew* There must be a better way to do this. I'm thinking a generator that successively applies a function to a vaule. */
const fillInDayRange = (startDate, endDate) => {
  var current = startDate.clone()
  var lst = [startDate]
  while (current.isBefore(endDate)) {
    current.add(1, "days")
    lst.push(current)
    current = current.clone()
  }
  return lst
}

export const HistoryView = connect(
  state => ({
    history: getHistory(state),
    currentEdit: getCurrentlyEditing(state),
    range: getRange(state),
  }),
  //(dispatch: any) => ({ fetchData: () => dispatch(runFetchHistory()) }),
)(History)
