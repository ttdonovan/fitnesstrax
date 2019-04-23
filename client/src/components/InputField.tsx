import React from "react"

export interface Props {
  value: string | null
  onChange: (_: { value: string }) => void
  classNames: Array<string>
}

const InputField: React.SFC<Props> = ({
  classNames,
  onChange,
  value,
}: Props) => (
  <input
    type="text"
    value={value || undefined}
    className={classNames.join(" ")}
    onChange={ev => onChange({ value: ev.target.value })}
    placeholder="Enter your login token"
  />
)

export default InputField
