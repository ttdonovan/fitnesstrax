import _ from "lodash/fp"
import React from "react"
import moment from "moment-timezone"

import { classnames, ClassNames } from "../../classnames"
import * as types from "../../types"
import TimeDistanceRecordView from "./TimeDistance"
import WeightRecordView from "./Weight"

interface Props {
  date: string
  records: Array<types.Record>
}

const Record: React.SFC<Props> = ({ date, records }: Props) => (
  <div>
    <div>{date}</div>
    {_.map((r: types.Record) => (
      <div>{r.date.format("YYYY-MM-DD hh:mm:ss ZZ")}</div>
    ))(records)}
    <hr />
  </div>
)

export default Record

/*
import cns from "classnames"
import React from "react"
import math from "mathjs"
import moment from "moment"
import { connect } from "react-redux"
import _ from "lodash/fp"

import { timeDistanceSample, weightSample } from "../client"
import {
  isSomething,
  listToMap,
  //nub,
  renderDate,
  renderDistance,
  renderDuration,
} from "../common"
import {
  cancelEditEntry,
  editEntry,
  //runFetchHistory,
  runSaveTimeDistance,
  runSaveWeight,
} from "../state/actions"
import { TimeDistanceRecord, WeightRecord } from "../types"
import { TimeDistance, TimeDistanceEdit } from "./TimeDistanceRow"
import { WeightForm, WeightEditForm } from "./WeightForm"
import { SetRepRow } from "./SetRepRow"
import { DailySummary } from "./DailySummary"
*/

/*
const distanceFieldStyle = {
  display: "inline",
  padding: 1,
  margin: 0,
  width: "4em",
}
const setsFieldStyle = { display: "inline", padding: 1, margin: 0 }

export interface Props {
  date: moment.Moment
  data: {
    weightRecord: WeightRecord | null
    timeDistanceRecords: Array<TimeDistanceRecord>
  }
}

export const DailyEntryView: React.SFC<Props> = ({
  date,
  data: { weightRecord, timeDistanceRecords },
}: Props) => (
  <div key={renderDate(date)}>
    <h2>
      <div className={cns("DateDisplay")}>{renderDate(date)}</div>
      <button
        type="button"
        style={{ float: "right" }}
        onClick={ev => this.props.onEdit(date)}
      >
        Edit
      </button>
    </h2>
    <div>
      <div className="WeightRecordView">
        <WeightForm value={weightRecord} />
      </div>
      <table className="TimeDistanceRecordView">
        {timeDistanceRecords.map(e => (
          <TimeDistance data={e} />
        ))}
      </table>

      <DailySummary tdEntries={timeDistanceRecords} />
    </div>
  </div>
)
*/

/*
export const DailyEntryViewR = connect(
  st => ({}),
  dispatch => ({ onEdit: date => dispatch(editEntry(date)) }),
)(DailyEntryView)
*/

// interface DailyEntryEditProps {
//   date: moment.Moment
//   data: any
//   onCancel: any
//   onSave: any
// }
//
// class DailyEntryEditState {
//   weight: WeightRecord
//   timeDistanceRows: Array<TimeDistanceRecord>
//   newRow: any
//   newRowWidget: any
// }
//
// class DailyEntryEdit extends React.Component<
//   DailyEntryEditProps,
//   DailyEntryEditState
// > {
//   constructor(props) {
//     super(props)
//
//     /* TODO: This needs to be brought up for three different use cases:
//          * a) there is no data at all available
//          * b) there is data available, but not for a particular day
//          * c) there is data available for this day
//          *
//          * At the moment, I handle only case c. Case b requires a history entry
//          * that contains a date but nothing more. Case a requires no data
//          * whatsover. It can happen when there is no data in the data store,
//          * but it can also happen as a result of pressing the "add a new
//          * record" button at the top. In general, users are probably going to
//          * click on a particular day to add a record, but it I also have use
//          * cases in which I want to enter a record with no such prompting.
//          */
//     this.state = {
//       weight:
//         isSomething(props.data) && isSomething(props.data.weight)
//           ? props.data.weight.clone()
//           : null,
//       // : weightSample(null, this.props.date, math.unit(0, 'kg'), math.unit(0, 'kg'))
//       timeDistanceRows:
//         isSomething(props.data) && isSomething(props.data.timeDistance)
//           ? props.data.timeDistance.map(e => e.clone())
//           : [],
//       newRow: null,
//       newRowWidget: null,
//     }
//   }
//
//   /*
//   updateWeight(newVal: math.Unit) {
//     if (isSomething(this.state.weight)) {
//       const updatedWeight = this.state.weight.clone()
//       updatedWeight.weight = newVal
//       this.setState({
//         weight: updatedWeight,
//       })
//     } else {
//       this.setState({
//         //weight: weightSample(null, this.props.date, newVal, math.unit(0, "kg")),
//         weight: weightSample(null, this.props.date, newVal),
//       })
//     }
//   }
//   */
//
//   render() {
//     /* TODO: watch the weight validation field and disable save if the field is currently invalid */
//     /*
//     return (
//       <div key={renderDate(this.props.date)}>
//         <h2> {renderDate(this.props.date)} </h2>
//         <div>
//           Weight:
//           <WeightEditForm
//             value={this.state.weight}
//             onUpdate={w => this.updateWeight(w)}
//           />
//         </div>
//         <table>
//           <tbody>
//             {this.state.timeDistanceRows.map(e => (
//               <TimeDistanceEdit
//                 {...e}
//                 onUpdateDate={value => (e.date = value)}
//                 onUpdateDistance={value => (e.distance = value)}
//                 onUpdateDuration={value => (e.duration = value)}
//               />
//             ))}
//           </tbody>
//         </table>
//         <WorkoutPulldown
//           onSelect={(option, evt) => this.setNewRow(option, evt)}
//         />
//         {this.state.newRowWidget}
//         <button
//           type="button"
//           onClick={ev => this.props.onSave(this.props.data, this.state)}
//         >
//           Save
//         </button>
//         <button type="button" onClick={ev => this.props.onCancel()}>
//           Cancel
//         </button>
//       </div>
//     )
//     */
//     return <div />
//   }
//
//   /*
//   setNewRow(option, evt) {
//     if (option == "Cycling" || option == "Running") {
//       var newRow = timeDistanceSample(
//         null,
//         moment(),
//         option,
//         math.unit(0, "km"),
//         math.unit(0, "s"),
//       )
//       this.setState({
//         newRow: newRow,
//         newRowWidget: (
//           <TimeDistanceEdit
//             activity={option}
//             onUpdateDate={value => (newRow.date = value)}
//             onUpdateDistance={value => (newRow.distance = value)}
//             onUpdateDuration={value => (newRow.duration = value)}
//           />
//         ),
//       })
//     }
//   }
//   */
// }

/*
export const DailyEntryEditView = connect(
  () => ({}),
  (dispatch: any) => ({
    onCancel: () => dispatch(cancelEditEntry()),
    onSave: (initialData, currentData) => {
      saveDailyEntryEdit(dispatch, initialData, currentData)
      dispatch(cancelEditEntry())
      //dispatch(runFetchHistory())
    },
  }),
)(DailyEntryEdit)
*/

// const saveDailyEntryEdit = (dispatch, initialData, currentData) => {
//   console.log(currentData)
//   if (
//     (!isSomething(initialData) && isSomething(currentData.weight)) ||
//     (isSomething(initialData) &&
//       !isSomething(initialData.weight) &&
//       isSomething(currentData.weight)) ||
//     (isSomething(initialData) &&
//       isSomething(initialData.weight) &&
//       isSomething(currentData.weight) &&
//       !initialData.weight.weight.equals(currentData.weight.weight))
//   ) {
//     dispatch(runSaveWeight(currentData.weight))
//   }
//
//   /* timeDistance scenarios
//      * there were none and now there is a new row
//      * there were existing rows and one of them is being changed
//      */
//   if (currentData.newRow) {
//     dispatch(runSaveTimeDistance(currentData.newRow))
//   }
//
//   const initialTdrs =
//     isSomething(initialData) && isSomething(initialData.timeDistance)
//       ? listToMap(e => e.uuid, initialData.timeDistance)
//       : {}
//   const tdrs =
//     isSomething(currentData) && isSomething(currentData.timeDistanceRows)
//       ? listToMap(e => e.uuid, currentData.timeDistanceRows)
//       : {}
//   const keys = _.uniq([].concat(Object.keys(initialTdrs), Object.keys(tdrs)))
//
//   keys.map(k => {
//     console.log(k, initialTdrs[k], tdrs[k])
//     if (!initialTdrs[k] && tdrs[k]) {
//       console.log("save a new record? ", k)
//     } else if (initialTdrs[k] && !tdrs[k]) {
//       console.log("delete a record: ", k)
//     } else if (!initialTdrs[k].equals(tdrs[k])) {
//       console.log("save an updated record:", k)
//       dispatch(runSaveTimeDistance(tdrs[k]))
//     } else {
//       console.log("do nothing: ", k)
//     }
//   })
//
//   // this should throw an error if the number of tdrs doesn't match the number of rows in the currentData
//   //
//   // if (   (! isSomething(initialData) && isSomething(currentData.timeDistance)
//   //     || (isSomething(initialData) && ! isSomething
// }

/*
const WorkoutPulldown = props => (
  <div key="workout-pulldown" className="dropdown">
    <button
      type="button"
      className="btn btn-outline-primary dropdown-toggle"
      id="dropdownMenuButton"
      data-toggle="dropdown"
      aria-haspopup="true"
      aria-expanded="false"
    >
      Add workout
    </button>
    <div className="dropdown-menu" aria-labelledby="dropdownMenuButton">
      <a
        className="dropdown-item"
        href="#"
        onClick={e => props.onSelect("Cycling", e)}
      >
        Cycling
      </a>
      <a
        className="dropdown-item"
        href="#"
        onClick={e => props.onSelect("Running", e)}
      >
        Running
      </a>
    </div>
  </div>
)
*/

/*
            <a className="dropdown-item" href="#">Crunches</a>
            <a className="dropdown-item" href="#">Pushups</a>
            <a className="dropdown-item" href="#">Situps</a>
            <a className="dropdown-item" href="#">Steps</a>
            */
