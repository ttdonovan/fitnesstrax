import { shallow } from "enzyme"
import math from "mathjs"
import moment from "moment"
import React from "react"

import { DailyEntryView } from "./DailyEntry"
import Option from "../option"
import {
  TimeDistanceActivity,
  TimeDistanceRecord,
  WeightRecord,
} from "../types"

describe("DailyEntryView", () => {
  it("renders with no data", () => {
    const date = moment([2019, 0, 1, 0, 0, 0])
    const wrapper = shallow(
      <DailyEntryView
        date={date}
        data={{
          weightRecord: null,
          timeDistanceRecords: [],
        }}
      />,
    )
    expect(wrapper.find(".DateDisplay").exists()).toBe(true)
    expect(wrapper.find(".WeightRecordView").exists()).toBe(true)
    expect(wrapper.find(".TimeDistanceRecordView").children().length).toEqual(0)
  })

  it("renders an entry with data", () => {
    const date = moment([2019, 0, 1, 0, 0, 0])
    const weightRecord = new WeightRecord(
      "weight-sample-uuid",
      moment([2019, 0, 1, 0, 0, 0]),
      math.unit(15, "kg"),
    )
    const timeDistanceRecords = [
      new TimeDistanceRecord(
        "td-sample-uuid-1",
        moment([2019, 0, 1, 1, 0, 0]),
        TimeDistanceActivity.Running,
        Option.Some(math.unit(5000, "m")),
        Option.Some(moment.duration(1800, "s")),
      ),
      new TimeDistanceRecord(
        "td-sample-uuid-1",
        moment([2019, 0, 1, 2, 0, 0]),
        TimeDistanceActivity.Cycling,
        Option.Some(math.unit(5000, "m")),
        Option.Some(moment.duration(1800, "s")),
      ),
    ]
    const wrapper = shallow(
      <DailyEntryView
        date={date}
        data={{
          weightRecord: weightRecord,
          timeDistanceRecords: timeDistanceRecords,
        }}
      />,
    )
    expect(wrapper.find(".DateDisplay").exists()).toBe(true)
    expect(wrapper.find(".WeightRecordView").exists()).toBe(true)
    expect(wrapper.find(".TimeDistanceRecordView").children().length).toEqual(2)
  })
})
