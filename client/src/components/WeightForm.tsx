import React from "react"
import math from "mathjs"

import { isSomething, renderWeight, parseUnit } from "../common"
import { TextEditForm } from "./ValidatedText"

interface Props {
  value: any
}

export const WeightForm: React.SFC<Props> = ({ value }: Props) => (
  <React.Fragment>
    isSomething(this.props.value) ? (
    <p> {renderWeight(this.props.value.weight)} </p>) : (<p> </p>)
  </React.Fragment>
)

export const WeightEditForm = ({
  value,
  onUpdate,
}: {
  value: any
  onUpdate: any
}) => (
  <TextEditForm
    value={this.props.value ? this.props.value.weight : math.unit(0, "kg")}
    render={renderWeight}
    parse={parseUnit}
    onUpdate={value => this.props.onUpdate(value)}
  />
)
