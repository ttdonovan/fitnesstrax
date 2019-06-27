import { Option } from "ld-ambiguity"
import { Duration } from "luxon"
import React from "react"

import { classnames, ClassNames } from "../classnames"

interface Props {
  duration: Option<Duration>
}

const Duration_: React.SFC<Props> = ({ duration }: Props) => (
  <React.Fragment>
    {duration
      .map(d => {
        if (d.as("hours") >= 1) return d.toFormat("h:mm:ss")
        else if (d.as("minutes") >= 1) return d.toFormat("m:ss")
        else return d.toFormat("s")
      })
      .or("")}
  </React.Fragment>
)

export default Duration_
