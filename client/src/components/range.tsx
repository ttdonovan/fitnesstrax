import React from "react"

import { classnames, ClassNames } from "../classnames"
import { Date } from "../datetimetz"
import * as types from "../types"

interface Props {
  classes: ClassNames
  range: types.Range<Date>
}

const Range: React.SFC<Props> = ({ classes, range }: Props) => (
  <div className={classnames(classes)}>
    {range.start.toString()} - {range.end.toString()}
  </div>
)

export default Range
