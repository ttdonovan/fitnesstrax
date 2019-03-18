import React from "react";
import math from "mathjs";

import { isSomething, renderWeight, parseUnit } from "../common";
import { TextEditForm } from "./ValidatedText";

export const WeightForm = ({ value }: { value: any }) =>
  isSomething(this.props.value) ? (
    <p> {renderWeight(this.props.value.weight)} </p>
  ) : (
    <p> </p>
  );

export const WeightEditForm = ({
  value,
  onUpdate
}: {
  value: any;
  onUpdate: any;
}) => (
  <TextEditForm
    value={this.props.value ? this.props.value.weight : math.unit(0, "kg")}
    render={renderWeight}
    parse={parseUnit}
    onUpdate={value => this.props.onUpdate(value)}
  />
);
