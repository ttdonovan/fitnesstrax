import React from "react"
import moment from "moment"
import math from "mathjs"

import { maybe } from "../common"
import { DateForm, DateEditForm } from "./DateForm"
import { WeightEditForm } from "./WeightForm"

export interface Props {
  date: moment.Moment
  weight: math.Unit
  onSave: any
}

export class State {
  date: moment.Moment
  weight: math.Unit
}

export class NewDay extends React.Component<Props, State> {
  constructor(props) {
    super(props)

    this.state = {
      date: this.props.date,
      weight: this.props.weight,
    }
  }

  addWeight() {
    maybe(this.props.onSave)(this.state)
  }

  render() {
    return (
      <div>
        <table>
          <tbody>
            <tr>
              {" "}
              <td>
                {" "}
                <DateEditForm
                  value={this.props.date}
                  onUpdate={value => this.setState({ date: value })}
                />{" "}
              </td>
              <td>
                {" "}
                <WeightEditForm
                  value={this.props.weight}
                  onUpdate={value => this.setState({ weight: value })}
                />{" "}
              </td>
              <td>
                {" "}
                <button
                  type="button"
                  className="btn-primary"
                  onClick={evt => this.addWeight()}
                >
                  Add Weight Entry
                </button>{" "}
              </td>{" "}
            </tr>
          </tbody>
        </table>
      </div>
    )
  }
}
