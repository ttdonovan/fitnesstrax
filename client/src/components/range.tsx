import React from "react"

import { classnames, ClassNames } from "../classnames"
import * as types from "../types"

interface Props {
  classes: ClassNames
  range: types.Range
}

const Range: React.SFC<Props> = ({ classes, range }: Props) => (
  <div className={classnames(classes)}>
    {range.start.toFormat("yyyy-MM-dd")} - {range.end.toFormat("yyyy-MM-dd")}
  </div>
)

export default Range
