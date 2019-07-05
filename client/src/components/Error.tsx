import React from "react"

export interface Props {
  msg: string
}

const Error: React.SFC<Props> = ({ msg }: Props) => (
  <div className="l-error error">
    <div> {msg} </div>
  </div>
)

export default Error
