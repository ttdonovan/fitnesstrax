import React from "react"

import { maybe, isSomething } from "../common"

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

export interface Props<A> {
  value: A | null
  render: (A) => string
  parse: (string) => A | null
  onUpdate: ((value) => void) | null
}

class State<A> {
  text: string | null
  value: A
}

export class TextEditForm<A> extends React.Component<Props<A>, object> {
  state: State<A>

  constructor(props: Props<A>) {
    super(props)

    this.state = {
      text: maybe(props.render)(props.value),
      value: props.value,
    }
  }

  update(evt) {
    const { parse, onUpdate } = this.props
    var res = parse(evt.target.value)
    this.setState({ text: evt.target.value, value: res })
    if (isSomething(res) && isSomething(onUpdate)) {
      onUpdate(res)
    }
  }

  render() {
    var valid = isSomething(this.state.value)
      ? ["has-success", "form-control-success"]
      : ["has-danger", "form-control-danger"]
    return (
      <span className={valid[0]}>
        <input
          type="text"
          className={"form-control " + valid[1]}
          value={this.state.text}
          onChange={evt => this.update(evt)}
        />
      </span>
    )
  }
}
