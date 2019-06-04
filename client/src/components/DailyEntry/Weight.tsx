import React from "react"
import { classnames, ClassNames } from "../../classnames"

import * as types from "../../types"

interface Props {
  record: types.WeightRecord
}

const WeightRecord: React.SFC<Props> = ({ record }) => (
  <div className="record weight">
    <div>{record.weight.toString()}</div>
  </div>
)

export default WeightRecord
