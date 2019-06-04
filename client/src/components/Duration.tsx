import moment from "moment-timezone"
import "moment-duration-format"
import React from "react"

import "../moment-extensions"
import { classnames, ClassNames } from "../classnames"
import Option from "../option"

interface Props {
  duration: Option<moment.Duration>
}

const Duration: React.SFC<Props> = ({ duration }: Props) => (
  <React.Fragment>{duration.map(d => d.format()).or("")}</React.Fragment>
)

export default Duration
