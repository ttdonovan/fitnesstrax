import { Option, Result } from "ld-ambiguity"
import React from "react"

import * as csn from "../../classnames"
import InputField from "../InputField"
import "./style.css"

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
  parse: (_: string) => Result<Option<A>, string>
  onChange: ((_: Option<A>) => void)
}

interface State<A> {
  text: string
  value: Option<A>
  valid: boolean
}

export class ValidatedInputField<A> extends React.Component<
  Props<A>,
  State<A>
> {
  state: State<A>

  constructor(props: Props<A>) {
    super(props)

    this.state = {
      text: props.value.map(props.render).or(""),
      value: props.value,
      valid: true,
    }
  }

  update(value: string) {
    const { parse, onChange } = this.props
    const res = parse(value)
    if (res.isOk()) {
      this.setState({ text: value, value: res.unwrap(), valid: true })
      res.map(v => onChange(v))
    } else {
      this.setState({ text: value, value: Option.None(), valid: false })
    }
  }

  render() {
    const { placeholder } = this.props
    const { value, valid } = this.state
    const validityClass = valid
      ? { valid: true, invalid: false }
      : { valid: false, invalid: true }
    return (
      <div className={csn.classnames(validityClass)}>
        <InputField
          classNames={validityClass}
          value={this.state.text}
          onChange={value => this.update(value)}
          placeholder={placeholder}
        />
      </div>
    )
  }
}

export default ValidatedInputField
