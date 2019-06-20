import React from "react"

import "./style.css"

interface Props {
  children: React.ReactFragment
}

const Card: React.SFC<Props> = ({ children }: Props) => (
  <div className="l-card card">{children}</div>
)

export default Card
