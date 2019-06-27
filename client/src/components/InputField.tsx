import { Option } from "ld-ambiguity"
import React, { ChangeEvent } from "react"

import * as csn from "../classnames"

export interface Props {
  value: Option<string>
  onChange: (_: string) => void
  classNames?: csn.ClassNames
  placeholder: string
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
    onChange={(ev: ChangeEvent<HTMLInputElement>) => onChange(ev.target.value)}
    placeholder={placeholder}
  />
)

export default InputField
