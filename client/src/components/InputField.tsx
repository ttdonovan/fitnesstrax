import React from "react"
import * as csn from "../classnames"

import Option from "../option"

export interface Props {
  value: Option<string>
  onChange: (_: string) => void
  classNames?: csn.ClassNames
  placeholder: string
}

interface Event {
  target: HTMLElement
}

const InputField: React.SFC<Props> = ({
  classNames,
  onChange,
  value,
  placeholder,
}: Props) => (
  <input
    type="text"
    value={value.or("")}
    className={classNames ? csn.classnames(classNames) : ""}
    onChange={ev => onChange(ev.target.value)}
    placeholder={placeholder}
  />
)

export default InputField
