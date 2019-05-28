import React from "react"
import math from "mathjs"
import moment from "moment"

import { nub, renderDistance, renderDuration } from "../common"
import { TimeDistanceSummary } from "./TimeDistanceRow"
import { TimeDistanceActivity, TimeDistanceRecord } from "../types"

export const DailySummary = ({
  tdEntries,
}: {
  tdEntries: Array<TimeDistanceRecord>
}) => {
  const activities: Array<TimeDistanceActivity> = nub(
    this.props.tdEntries.map(td => td.activity),
  )
  return (
    <table>
      <tbody>
        {activities.map(a => (
          <TimeDistanceSummary activity={a} entries={this.props.tdEntries} />
        ))}
      </tbody>
    </table>
  )
}
