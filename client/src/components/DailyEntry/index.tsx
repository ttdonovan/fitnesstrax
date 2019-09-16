import { Option, Result } from "ld-ambiguity"
import _ from "lodash/fp"
import React from "react"
import moment from "moment-timezone"

import { classnames, ClassNames } from "../../classnames"
import { first } from "../../common"
import * as types from "../../types"
import { UserPreferences } from "../../settings"
import { DateTimeTz, Date } from "../../datetimetz"
import Card from "../Card"
import Row from "../Row"
import { Workout, NewWorkout } from "../Workout"
import AddWorkout from "./AddWorkout"
import Summary from "./Summary"
import StepRecordComponent from "./Steps"
import WeightRecordComponent from "./Weight"

import "./style.css"

interface Props {
  date: Date
  prefs: UserPreferences
  records: Array<types.Record<types.RecordTypes>>
  saveRecords: (
    _: Array<types.Record<types.RecordTypes> | types.RecordTypes>,
  ) => Promise<Result<null, string>>
}

interface State {
  newRecord: Option<types.RecordTypes>
}

class DailyEntry extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props)
    this.state = {
      newRecord: Option.None(),
    }
  }

  weightRecord = (): Option<types.Record<types.WeightRecord>> =>
    first(_.filter((r: types.Record<types.RecordTypes>): boolean =>
      types.isWeightRecord(r.data),
    )(this.props.records) as Array<types.Record<types.WeightRecord>>)

  stepRecord = (): Option<types.Record<types.StepRecord>> =>
    first(_.filter((r: types.Record<types.RecordTypes>): boolean =>
      types.isStepRecord(r.data),
    )(this.props.records) as Array<types.Record<types.StepRecord>>)

  save = (
    uuid: Option<string>,
    data: types.RecordTypes,
  ): Promise<Result<null, string>> => {
    const uuid_ = uuid.unwrap_()
    const savePromise = uuid_
      ? this.props.saveRecords([new types.Record(uuid_, data)])
      : this.props.saveRecords([data])
    return savePromise
  }

  cancelWorkout = () => this.setState({ newRecord: Option.None() })

  addWorkout = (value: any) => {
    if (types.isSetRepActivity(value.value)) {
      this.setState({
        newRecord: Option.Some(
          new types.SetRepRecord(
            DateTimeTz.fromDate(this.props.date, this.props.prefs.timezone),
            value.value,
            [],
          ),
        ),
      })
    } else if (types.isTimeDistanceActivity(value.value)) {
      this.setState({
        newRecord: Option.Some(
          new types.TimeDistanceRecord(
            DateTimeTz.fromDate(this.props.date, this.props.prefs.timezone),
            value.value,
            Option.None(),
            Option.None(),
            Option.None(),
          ),
        ),
      })
    }
  }

  render = () => {
    return (
      <div>
        <Card title={this.props.date.toString()}>
          <Row classNames={{ "l-4-column": true }}>
            <WeightRecordComponent
              date={this.props.date}
              prefs={this.props.prefs}
              record={this.weightRecord()}
              save={this.save}
            />

            <StepRecordComponent
              date={this.props.date}
              prefs={this.props.prefs}
              record={this.stepRecord()}
              save={this.save}
            />
            <Summary prefs={this.props.prefs} records={this.props.records} />
          </Row>

          <React.Fragment>
            <div className="activity-header">Activities</div>
            {_.map((r: types.Record<types.RecordTypes>) => (
              <div className="record">
                <Workout prefs={this.props.prefs} record={r} save={this.save} />
              </div>
            ))(this.props.records)}
          </React.Fragment>

          {this.state.newRecord.isSome() ? (
            <React.Fragment>
              <NewWorkout
                prefs={this.props.prefs}
                record={this.state.newRecord.unwrap()}
                save={this.save}
                cancel={this.cancelWorkout}
              />
            </React.Fragment>
          ) : null}

          <AddWorkout prefs={this.props.prefs} onSelect={this.addWorkout} />
        </Card>
      </div>
    )
  }
}

export default DailyEntry
