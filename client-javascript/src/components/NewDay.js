import React from 'react';

import { maybe } from '../common'
import { DateForm, DateEditForm } from './DateForm'
import { WeightEditForm } from './WeightForm';

export class NewDay extends React.Component {
    constructor (props) {
        super(props)

        this.state = { date: this.props.date
                     , weight: this.props.weight
                     }
    }

    addWeight () {
        maybe(this.props.onSave)(this.state)
    }

    render () {
        return (
            <div>
                <table>
                <tbody>
                <tr> <td> <DateEditForm value={this.props.date}
                                        onUpdate={(value) => this.setState({date: value})}/> </td>
                     <td> <WeightEditForm value={this.props.weight}
                                          onUpdate={(value) => this.setState({weight: value})}/> </td>
                     <td> <button type="button"
                                  className="btn-primary"
                                  onClick={(evt) => this.addWeight()}>Add Weight Entry</button> </td> </tr>
                </tbody>
                </table>
            </div>
            )
    }
}

