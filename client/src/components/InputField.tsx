import React from "react"
import * as csn from "../classnames"

export interface Props {
  value: string | null
  onChange: (_: { value: string }) => void
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
    value={value || undefined}
    className={classNames ? csn.classnames(classNames) : ""}
    onChange={ev => onChange({ value: ev.target.value })}
    placeholder={placeholder}
  />
)

export default InputField
