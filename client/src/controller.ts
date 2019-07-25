import { Result, sequenceResult } from "ld-ambiguity"
import _ from "lodash/fp"

import Client from "./client"
import * as redux from "./redux"
import { Date, DateTimeTz } from "./datetimetz"
import { Range, Record, RecordTypes } from "./types"
import { UserPreferences } from "./settings"

class Controller {
  client: Client
  store: redux.AppStore

  constructor(appUrl: string, store: redux.AppStore) {
    this.client = new Client(appUrl)
    this.store = store
  }

  authenticate = (token: string): Promise<void> =>
    this.client.authenticate(token).then(ok => {
      if (ok) {
        localStorage.setItem("credentials", token)
        this.store.dispatch(redux.setAuthToken(token))
      } else {
        this.setError("Invalid authentication token")
      }
    })

  logout = () => this.store.dispatch(redux.clearAuthToken())

  setError = (errMsg: string) => {
    this.store.dispatch(redux.setError(errMsg))
    new Promise(r =>
      setTimeout(() => {
        this.store.dispatch(redux.clearError())
        r()
      }, 5000),
    )
  }

  fetchRecords = (range: Range<DateTimeTz>): Promise<void> => {
    const authToken = redux.getAuthToken(this.store.getState())
    if (authToken) {
      return this.client
        .fetchHistory(authToken, range.start, range.end)
        .then((records: Result<Array<Record<RecordTypes>>, string>) => {
          records
            .map(r => this.store.dispatch(redux.saveRecords(r)))
            .mapErr(err => this.setError(err))
        })
    }
    return new Promise(r => null)
  }

  saveRecord = (
    token: string,
    r: Record<RecordTypes> | RecordTypes,
  ): Promise<Result<null, string>> =>
    this.client
      .saveRecord(token, r)
      .then((res: Result<Record<RecordTypes>, string>) => {
        if (res.isOk()) {
          this.store.dispatch(redux.saveRecords([res.unwrap()]))
          return Result.Ok(null)
        } else {
          return Result.Err(res.unwrapErr())
        }
      })

  saveRecords = (
    records: Array<Record<RecordTypes> | RecordTypes>,
  ): Promise<Result<null, string>> => {
    const authToken = redux.getAuthToken(this.store.getState())

    if (authToken) {
      const authToken_ = authToken as string
      return Promise.all(
        _.map((r: Record<RecordTypes> | RecordTypes) =>
          this.saveRecord(authToken_, r),
        )(records),
      ).then((r: Array<Result<null, string>>) =>
        sequenceResult(r)
          .map(_ => null)
          .mapErr(err => {
            this.setError(err)
            return err
          }),
      )
    }
    return new Promise(r => r())
  }

  setRange = (range: Range<Date>) => {
    history.pushState(
      {},
      "",
      `?start=${range.start.toString()}&end=${range.end.toString()}`,
    )
    this.store.dispatch(redux.setRange(range))
  }

  setPreferences = (prefs: UserPreferences): void => {
    localStorage.setItem("timezone", prefs.timezone.name)
    localStorage.setItem("units", prefs.units.sym)
    localStorage.setItem("language", prefs.language.sym)
    this.store.dispatch(redux.setPreferences(prefs))
  }
}

export default Controller
