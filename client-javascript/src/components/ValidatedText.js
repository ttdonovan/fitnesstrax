import React from 'react';

import { maybe, isSomething } from '../common';

/* Required parameters:
 *
 * value: the data value to be rendered
 * render: (value) => str
 * parser: (str) => maybe value
 *
 * Optional parameter:
 *
 * onUpdate: (value) => action to take when a valid value is in the field
 */
export class TextEditForm extends React.Component {
    constructor (props) {
        super(props)

        this.state = { 'text': maybe(this.props.render)(this.props.value)
                     , 'value': this.props.value
                     }
    }

    update (evt) {
        var res = this.props.parse(evt.target.value);
        this.setState({ 'text': evt.target.value, 'value': res })
        if (  isSomething(res)
           && isSomething(this.props.onUpdate) ) {
            this.props.onUpdate(res)
        }
    }

    render () {
        var valid = isSomething(this.state.value)
                        ? ['has-success', 'form-control-success']
                        : ['has-danger', 'form-control-danger']
        return <span className={valid[0]}>
               <input type="text"
                      className={"form-control " + valid[1]}
                      value={this.state.text}
                      onChange={(evt) => this.update(evt)} />
               </span>
    }

}

