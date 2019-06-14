import React from "react"

import "./style.css"

interface Props {
  children: React.ReactFragment
}

const CenterPanel: React.SFC<Props> = ({ children }: Props) => (
  <div className="center-panel">
    <div className="l-side" />
    <div className="l-center">{children}</div>
    <div className="l-side" />
  </div>
)

export default CenterPanel
