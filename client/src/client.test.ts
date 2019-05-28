import math from "mathjs"
import moment from "moment-timezone"

import { parseTimestamp, toRfc3339 } from "./common"
import { fetchHistory } from "./client"
import { Option, TimeDistanceActivity, TimeDistanceRecord } from "./types"

describe("fetchHistory", () => {
  beforeEach(() => {
    fetchMock.resetMocks()
  })

  it("works even if there is no data available", async () => {
    fetchMock.mockResponseOnce("[]")

    const result = await fetchHistory(
      "http://localhost:9010",
      "auth-data",
      moment("2018-10-10T04:00:00Z"),
      moment("2018-10-16T04:00:00Z"),
    )

    expect(fetchMock).toHaveBeenCalledWith(
      "http://localhost:9010/api/history/all/2018-10-10T04:00:00Z/2018-10-16T04:00:00Z",
      {
        method: "GET",
        mode: "cors",
        headers: new Headers({
          accept: "application/json",
          authorization: "Bearer auth-data",
        }),
      },
    )
    expect(result).toEqual([])
  })

  it("works with a mix of data types", async () => {
    fetchMock.mockResponseOnce(
      '[{"id":"ae4bf2c4-9130-43d3-abb4-937c64d0d0f2","data":{"Weight":{"date":"2018-10-10T04:00:00Z","weight":86.2}}},{"id":"15f9c464-6427-4368-ab88-13875d47865f","data":{"TimeDistance":{"activity":"Running","comments":null,"date":"2018-11-14T17:30:00Z","distance":3640.0,"duration":1800.0}}}]',
    )

    const result = await fetchHistory(
      "http://localhost:9010",
      "auth-data",
      moment("2018-10-10T04:00:00Z"),
      moment("2018-10-16T04:00:00Z"),
    )

    expect(result).toHaveLength(2)

    const weightRecord = result.find(
      r => r.id === "ae4bf2c4-9130-43d3-abb4-937c64d0d0f2",
    )
    expect(weightRecord).toMatchObject({
      id: "ae4bf2c4-9130-43d3-abb4-937c64d0d0f2",
      date: parseTimestamp("2018-10-10T04:00:00Z").unwrap(),
      weight: math.unit(86.2, "kg"),
    })
    const tdRecord = result.find(
      r => r.id === "15f9c464-6427-4368-ab88-13875d47865f",
    )
    expect(tdRecord.id).toEqual("15f9c464-6427-4368-ab88-13875d47865f")
    expect((<TimeDistanceRecord>tdRecord).activity).toEqual(
      TimeDistanceActivity.Running,
    )
    expect(
      tdRecord.date.isSame(parseTimestamp("2018-11-14T17:30:00Z").unwrap()),
    ).toEqual(true)
    expect(
      (<TimeDistanceRecord>tdRecord).distance.map(d =>
        d.equals(math.unit(3640.0, "m")),
      ),
    ).toEqual(Option.Some(true))
    expect((<TimeDistanceRecord>tdRecord).duration).toEqual(
      Option.Some(moment.duration({ seconds: 1800.0 })),
    )
  })
})
