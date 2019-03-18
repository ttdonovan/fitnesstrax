import React from 'react';

import { isSomething, maybe, parseDate, renderDate } from '../common';
import { TextEditForm } from './ValidatedText';

export class DateForm extends React.Component {
    constructor (props) {
        super(props)
    }

    render () {
        return <div> {maybe(renderDate)(this.props.date)} </div>
    }
}


export class DateEditForm extends React.Component {
    constructor (props) {
        super(props)
    }

    render () {
        return <TextEditForm value={this.props.value}
                             render={renderDate}
                             parse={parseDate}
                             onUpdate={(value) => this.props.onUpdate(value)} />
    }
}

