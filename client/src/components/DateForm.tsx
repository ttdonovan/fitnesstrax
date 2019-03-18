import React from "react"
import * as moment from "moment"

import { isSomething, maybe, parseDate, renderDate } from "../common"
import { TextEditForm } from "./ValidatedText"

export const DateForm = ({ date }: { date: moment.Moment }) => (
  <div> {maybe(renderDate)(date)} </div>
)

export interface DateEditFormProps {
  value: moment.Moment
  onUpdate: (Moment) => void
}

export const DateEditForm = ({ value, onUpdate }: DateEditFormProps) => (
  <TextEditForm
    value={value}
    render={renderDate}
    parse={parseDate}
    onUpdate={value => onUpdate(value)}
  />
)
