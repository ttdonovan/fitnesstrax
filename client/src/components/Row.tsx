import React from "react"
import { classnames, ClassNames } from "../classnames"

interface Props {
  children: React.ReactFragment
  classNames?: ClassNames
}

const Row: React.SFC<Props> = ({ children, classNames }) => (
  <div
    className={classNames ? classnames(classNames) : ""}
    style={{ display: "flex", alignItems: "center" }}
  >
    {children}
  </div>
)

export default Row
