import React from "react"
import Calendar from "react-calendar"

import * as dtz from "../../datetimetz"
import { UserPreferences } from "../../settings"
import { Range } from "../../types"
import DatePicker from "../DatePicker"

import "./style.css"

interface Props {
  range: Range<dtz.Date>
  prefs: UserPreferences
  setRange: (d: Range<dtz.Date>) => void
}

const RangePicker: React.SFC<Props> = ({ range, prefs, setRange }: Props) => (
  <div className="range-picker">
    <DatePicker
      date={range.end}
      prefs={prefs}
      setBound={d => setRange(range.setEnd(d))}
    />
    <DatePicker
      date={range.start}
      prefs={prefs}
      setBound={d => setRange(range.setStart(d))}
    />
  </div>
)

export default RangePicker
