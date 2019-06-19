import math from "mathjs"
import { Duration } from "luxon"

import Client from "./client"
import DateTimeTz from "./datetimetz"
import Option from "./option"
import { TimeDistanceActivity, TimeDistanceRecord } from "./types"

describe("authenticate", () => {
  beforeEach(() => {
    fetchMock.resetMocks()
  })

  /* how do I set the retun code on a fetchMock? */
  it("returns true when the server accepts the token", async () => {
    fetchMock.mockResponseOnce("", { status: 204 })
    const client = new Client("http://localhost:9010")

    const result = await client.authenticate("abcdefg")
    expect(result).toBe(true)
    expect(fetchMock).toHaveBeenCalledWith(
      "http://localhost:9010/api/history/all",
      {
        method: "OPTIONS",
        mode: "cors",
        headers: new Headers({
          authorization: "Bearer abcdefg",
        }),
      },
    )
  })

  it("returns false when the server rejects the token", async () => {
    fetchMock.mockResponseOnce("", { status: 401 })
    const client = new Client("http://localhost:9010")

    const result = await client.authenticate("abcdefg")
    expect(result).toBe(false)
    expect(fetchMock).toHaveBeenCalledWith(
      "http://localhost:9010/api/history/all",
      {
        method: "OPTIONS",
        mode: "cors",
        headers: new Headers({
          authorization: "Bearer abcdefg",
        }),
      },
    )
  })

  it("returns false when the there is no token", async () => {
    fetchMock.mockResponseOnce("", { status: 401 })
    const client = new Client("http://localhost:9010")

    const result = await client.authenticate("")
    expect(result).toBe(false)
    expect(fetchMock).toHaveBeenCalledWith(
      "http://localhost:9010/api/history/all",
      {
        method: "OPTIONS",
        mode: "cors",
        headers: new Headers({
          authorization: "Bearer ",
        }),
      },
    )
  })
})

describe("fetchHistory", () => {
  beforeEach(() => {
    fetchMock.resetMocks()
  })

  it("works even if there is no data available", async () => {
    fetchMock.mockResponseOnce("[]")
    const client = new Client("http://localhost:9010")

    const result = await client.fetchHistory(
      "auth-data",
      DateTimeTz.fromString("2018-10-10T04:00:00Z").unwrap(),
      DateTimeTz.fromString("2018-10-16T04:00:00Z").unwrap(),
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
      '[{"id":"ae4bf2c4-9130-43d3-abb4-937c64d0d0f2","data":{"Weight":{"date":"2018-10-10T04:00:00+00:00 America/New_York","weight":86.2}}},{"id":"15f9c464-6427-4368-ab88-13875d47865f","data":{"TimeDistance":{"activity":"Running","comments":null,"date":"2018-11-14T17:30:00+00:00 America/New_York","distance":3640.0,"duration":1800.0}}}]',
    )

    const client = new Client("http://localhost:9010")

    const result = await client.fetchHistory(
      "auth-data",
      DateTimeTz.fromString("2018-10-10T04:00:00Z").unwrap(),
      DateTimeTz.fromString("2018-10-16T04:00:00Z").unwrap(),
    )

    expect(result).toHaveLength(2)

    const weightRecord = result.find(
      r => r.id === "ae4bf2c4-9130-43d3-abb4-937c64d0d0f2",
    )
    expect(weightRecord).toMatchObject({
      id: "ae4bf2c4-9130-43d3-abb4-937c64d0d0f2",
      date: DateTimeTz.fromString(
        "2018-10-10T04:00:00+00:00 America/New_York",
      ).unwrap(),
      weight: math.unit(86.2, "kg"),
    })
    const tdRecord = result.find(
      r => r.id === "15f9c464-6427-4368-ab88-13875d47865f",
    )
    expect(tdRecord && tdRecord.id).toEqual(
      "15f9c464-6427-4368-ab88-13875d47865f",
    )
    expect((<TimeDistanceRecord>tdRecord).activity).toEqual(
      TimeDistanceActivity.Running,
    )
    expect(
      tdRecord &&
        tdRecord.date.equals(
          DateTimeTz.fromString(
            "2018-11-14T17:30:00+00:00 America/New_York",
          ).unwrap(),
        ),
    ).toEqual(true)
    expect(
      (<TimeDistanceRecord>tdRecord).distance.map(d =>
        d.equals(math.unit(3640.0, "m")),
      ),
    ).toEqual(Option.Some(true))
    expect((<TimeDistanceRecord>tdRecord).duration).toEqual(
      Option.Some(Duration.fromObject({ seconds: 1800.0 })),
    )
  })
})
