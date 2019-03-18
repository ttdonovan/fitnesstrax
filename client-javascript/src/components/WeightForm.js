import React from 'react';
import math from 'mathjs';

import { isSomething, renderWeight, parseUnit } from '../common'
import { TextEditForm } from './ValidatedText'

export class WeightForm extends React.Component {
    render () {
        return (isSomething(this.props.value))
            ? <p> {renderWeight(this.props.value.weight)} </p>
            : <p> </p>
    }
}

export class WeightEditForm extends React.Component {
    render () {
        return <TextEditForm value={this.props.value ? this.props.value.weight : math.unit(0, 'kg')}
                             render={renderWeight}
                             parse={parseUnit}
                             onUpdate={(value) => this.props.onUpdate(value)}/>
    }
}

