import { Option } from "ld-ambiguity"
import React from "react"

import * as csn from "../classnames"
import InputField from "./InputField"

//import { maybe, isSomething } from "../common"

/* Required parameters:
 *
 * value: the data value to be rendered
 * render: (value) => str
 * parser: (str) => maybe value
 *
 * Optional parameter:
 *
 * onChange: (value) => action to take when a valid value is in the field
 */

export interface Props<A> {
  value: Option<A>
  placeholder: string
  render: (_: A) => string
  parse: (_: string) => Option<A>
  onChange: ((_: A) => void)
}

interface State<A> {
  text: Option<string>
  value: Option<A>
}

export class ValidatedInputField<A> extends React.Component<
  Props<A>,
  State<A>
> {
  state: State<A>

  constructor(props: Props<A>) {
    super(props)

    this.state = {
      text: props.value.map(props.render),
      value: props.value,
    }
  }

  update(value: string) {
    const { parse, onChange } = this.props
    const res = parse(value)
    this.setState({ text: Option.Some(value), value: res })
    res.map(v => onChange(v))
  }

  render() {
    const { placeholder } = this.props
    const { value } = this.state
    const valid = value
      .map(_ => ({
        valid: true,
      }))
      .or({ valid: false })
    return (
      <span className={csn.classnames(valid)}>
        <InputField
          classNames={valid}
          value={this.state.text}
          onChange={value => this.update(value)}
          placeholder={placeholder}
        />
      </span>
    )
  }
}

export default ValidatedInputField
