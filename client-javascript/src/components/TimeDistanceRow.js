import React from 'react'
import math from 'mathjs'
import moment from 'moment'
require('moment-duration-format')

import { divmod, intercalate, padStr
       , parseUnit, parseTime, renderTime
       , renderDistance
       , parseDuration, renderDuration } from '../common'
import { TextEditForm } from './ValidatedText'

const distanceFieldStyle = {display: "inline", padding: 1, margin: 0, width: "4em"};
const setsFieldStyle = {display: "inline", padding: 1, margin: 0};

/* Give this an "edit" field so that the user can edit the data in the component */
export class TimeDistance extends React.Component {
    render () {
        return (<tr key={this.props.data.uuid}>
                <td> {renderTime(this.props.data.date)} </td>
                <td> {this.props.data.activity} </td>
                <td> {renderDistance(this.props.data.distance)} </td>
                <td> {renderDuration(this.props.data.duration)} </td>
                <td> </td>
                </tr>)
    }
}


export class TimeDistanceEdit extends React.Component {
    render () {
        return <tr key={this.props.uuid ? this.props.uuid : 'new-row'}>
               <td> <TextEditForm value={this.props.date ? this.props.date : moment()}
                                  render={renderTime}
                                  parse={parseTime}
                                  onUpdate={(value) => this.props.onUpdateDate(value)} /> </td>
               <td> {this.props.activity} </td>
               <td> <TextEditForm value={this.props.distance ? this.props.distance : math.unit(0, 'km')}
                                  render={renderDistance}
                                  parse={parseUnit}
                                  onUpdate={(value) => this.props.onUpdateDistance(value)} /> </td>
               <td> <TextEditForm value={this.props.duration ? this.props.duration : moment.duration(0, 's')}
                                  render={renderDuration}
                                  parse={parseDuration}
                                  onUpdate={(value) => this.props.onUpdateDuration(value)} /> </td>
               </tr>
    }
}


export class TimeDistanceSummary extends React.Component {
    render () {
        const entries = this.props.entries.filter((td) => td.activity == this.props.activity)
        const distance = entries.map((td) => td.distance).reduce((a, b) => math.add(a, b), math.unit(0, 'km'))
        const duration = entries.map((td) => td.duration).reduce((a, b) => a.add(b), moment.duration(0))
        return <tr> <th> { this.props.activity } </th>
                    <td> { renderDistance(distance) } </td>
                    <td> { renderDuration(duration) } </td> </tr>
    }
}


