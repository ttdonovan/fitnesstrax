import React from "react"
import moment from "moment-timezone"
import { connect } from "react-redux"

import Controller from "../../controller"
import * as redux from "../../redux"
import { Range, Record } from "../../types"

interface Props {
  controller: Controller
  currentEdit: Record | null
  history: Map<string, Record>
  range: Range
}

class History extends React.Component<Props, {}> {
  componentDidMount() {
    this.props.controller.fetchRecords({
      start: moment("2017-10-23T22:09:00Z"),
      end: moment("2018-11-12T18:30:00Z"),
    })
  }

  render() {
    const { controller, currentEdit, history, range } = this.props
    console.log("HistoryView", history)
    return <div id="History" />
  }
}

const HistoryView = connect((state: redux.AppState) => ({
  currentEdit: redux.getCurrentlyEditing(state),
  history: redux.getHistory(state),
  range: redux.getRange(state),
}))(History)

export default HistoryView
