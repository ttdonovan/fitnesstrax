import React from "react"
import moment from "moment-timezone"

import { classnames, ClassNames } from "../classnames"
import * as types from "../types"

interface Props {
  classes: ClassNames
  range: types.Range
}

const Range: React.SFC<Props> = ({ classes, range }: Props) => (
  <div className={classnames(classes)}>
    {range.start.format("YY-MM-DD")} - {range.end.format("YY-MM-DD")}
  </div>
)

export default Range
