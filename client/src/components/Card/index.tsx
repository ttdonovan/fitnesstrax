import React from "react"

import "./style.css"

interface Props {
  title: string
  children: React.ReactFragment
}

const Card: React.SFC<Props> = ({ title, children }: Props) => (
  <div className="card">
    <div className="title">{title}</div>
    {children}
  </div>
)

export default Card
