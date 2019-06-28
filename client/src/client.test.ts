import math from "mathjs"
import { Duration } from "luxon"

import Client from "./client"
import { DateTimeTz } from "./datetimetz"
import { Option } from "ld-ambiguity"
import {
  Record,
  RecordTypes,
  Running,
  TimeDistanceRecord,
  WeightRecord,
} from "./types"

describe("authenticate", () => {
  beforeEach(() => {
    fetchMock.resetMocks()
  })

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

    const result = (await client.fetchHistory(
      "auth-data",
      DateTimeTz.fromString("2018-10-10T04:00:00Z").unwrap(),
      DateTimeTz.fromString("2018-10-16T04:00:00Z").unwrap(),
    )).unwrap()

    expect(fetchMock).toHaveBeenCalledWith(
      "http://localhost:9010/api/history/all/2018-10-10T04%3A00%3A00Z/2018-10-16T04%3A00%3A00Z",
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

    const result = (await client.fetchHistory(
      "auth-data",
      DateTimeTz.fromString("2018-10-10T04:00:00Z").unwrap(),
      DateTimeTz.fromString("2018-10-16T04:00:00Z").unwrap(),
    )).unwrap()

    expect(result).toHaveLength(2)

    const weightRecord = result.find(
      r => r.id === "ae4bf2c4-9130-43d3-abb4-937c64d0d0f2",
    )

    expect(weightRecord).toEqual(
      new Record(
        "ae4bf2c4-9130-43d3-abb4-937c64d0d0f2",
        new WeightRecord(
          DateTimeTz.fromString(
            "2018-10-10T04:00:00+00:00 America/New_York",
          ).unwrap(),
          math.unit(86.2, "kg"),
        ),
      ),
    )
    const tdRecord: Record<RecordTypes> = new Option<Record<RecordTypes>>(
      result.find(r => r.id === "15f9c464-6427-4368-ab88-13875d47865f"),
    ).unwrap()
    expect(tdRecord.id).toEqual("15f9c464-6427-4368-ab88-13875d47865f")
    expect((<TimeDistanceRecord>tdRecord.data).activity).toEqual(Running)
    expect(
      tdRecord &&
        tdRecord.data.date.equals(
          DateTimeTz.fromString(
            "2018-11-14T17:30:00+00:00 America/New_York",
          ).unwrap(),
        ),
    ).toEqual(true)
    expect(
      (<TimeDistanceRecord>tdRecord.data).distance.map(d =>
        d.equals(math.unit(3640.0, "m")),
      ),
    ).toEqual(Option.Some(true))
    expect((<TimeDistanceRecord>tdRecord.data).duration).toEqual(
      Option.Some(Duration.fromObject({ seconds: 1800.0 })),
    )
  })
})

describe("saveRecord", () => {
  beforeEach(() => {
    fetchMock.resetMocks()
  })

  it("saves a new weight record", async () => {
    fetchMock.mockResponseOnce(JSON.stringify("new-record-id"))
    const client = new Client("http://localhost:9010")

    const rec = new WeightRecord(
      DateTimeTz.fromString("2019-05-15T15:30:00Z America/New_York").unwrap(),
      math.unit(50, "kg"),
    )
    const res = await client.saveRecord("auth-data", rec)
    expect(fetchMock).toHaveBeenCalledWith(
      "http://localhost:9010/api/record/weight",
      {
        method: "PUT",
        mode: "cors",
        headers: new Headers({
          Accept: "application/json",
          "Content-Type": "application/json",
          Authorization: "Bearer auth-data",
        }),
        body: JSON.stringify({
          date: "2019-05-15T15:30:00Z America/New_York",
          weight: 50,
        }),
      },
    )
    expect(res.unwrap()).toEqual(
      new Record(
        "new-record-id",
        new WeightRecord(
          DateTimeTz.fromString(
            "2019-05-15T15:30:00.000Z America/New_York",
          ).unwrap(),
          math.unit(50, "kg"),
        ),
      ),
    )
  })

  it("saves an update to a weight record", async () => {
    fetchMock.mockResponseOnce(JSON.stringify("efgh-ijkl"))
    const client = new Client("http://localhost:9010")

    const time = DateTimeTz.fromString("2019-05-15T15:30:00Z America/New_York")
    const rec = new Record(
      "efgh-ijkl",
      new WeightRecord(
        DateTimeTz.fromString("2019-05-15T15:30:00Z America/New_York").unwrap(),
        math.unit(50, "kg"),
      ),
    )
    const res = await client.saveRecord("auth-data", rec)
    expect(fetchMock).toHaveBeenCalledWith(
      "http://localhost:9010/api/record/efgh-ijkl",
      {
        method: "POST",
        mode: "cors",
        headers: new Headers({
          Accept: "application/json",
          "Content-Type": "application/json",
          Authorization: "Bearer auth-data",
        }),
        body: JSON.stringify({
          Weight: {
            date: "2019-05-15T15:30:00Z America/New_York",
            weight: 50,
          },
        }),
      },
    )
    expect(res.unwrap()).toEqual(
      new Record(
        "efgh-ijkl",
        new WeightRecord(
          DateTimeTz.fromString(
            "2019-05-15T15:30:00.000Z America/New_York",
          ).unwrap(),
          math.unit(50, "kg"),
        ),
      ),
    )
  })
})
