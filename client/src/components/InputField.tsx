import React from "react"

export interface Props {
  value: string | null
  onChange: (_: { value: string }) => void
  classNames: Array<string>
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
    className={classNames.join(" ")}
    onChange={ev => onChange({ value: ev.target.value })}
    placeholder={placeholder}
  />
)

export default InputField
