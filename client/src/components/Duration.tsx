import { Option } from "ld-ambiguity"
import { Duration } from "luxon"
import React from "react"

import { classnames, ClassNames } from "../classnames"
import { renderDuration } from "../common"

interface Props {
  duration: Option<Duration>
}

const Duration_: React.SFC<Props> = ({ duration }: Props) => (
  <React.Fragment>{duration.map(d => renderDuration(d)).or("")}</React.Fragment>
)

export default Duration_
