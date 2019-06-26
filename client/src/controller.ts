import Client from "./client"
import _ from "lodash/fp"
import * as redux from "./redux"
import Result from "./result"
import { Range, Record, RecordTypes } from "./types"
import { UserPreferences } from "./userPrefs"

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
        this.store.dispatch(redux.setError("Invalid authentication token"))
      }
    })

  logout = () => this.store.dispatch(redux.clearAuthToken())

  fetchRecords = (range: Range): Promise<void> => {
    const authToken = redux.getAuthToken(this.store.getState())
    if (authToken) {
      return this.client
        .fetchHistory(authToken, range.start, range.end)
        .then((records: Result<Array<Record<RecordTypes>>, string>) => {
          this.store.dispatch(redux.saveRecords(records.unwrap()))
        })
    }
    return new Promise(r => null)
  }

  saveRecords = (
    records: Array<Record<RecordTypes> | RecordTypes>,
  ): Promise<void> => {
    const authToken = redux.getAuthToken(this.store.getState())
    if (authToken) {
      return Promise.all(
        _.map((r: Record<RecordTypes> | RecordTypes) => {
          this.client
            .saveRecord(authToken, r)
            .then((res: Result<Record<RecordTypes>, string>) =>
              res
                .map(rec => this.store.dispatch(redux.saveRecords([rec])))
                .mapErr(err => {
                  throw new Error(`save exception ${err}`)
                }),
            )
        })(records),
      ).then(r => {})
    }
    return new Promise(r => r())
  }

  setPreferences = (prefs: UserPreferences): void => {
    localStorage.setItem("timezone", prefs.timezone.name)
    localStorage.setItem("units", prefs.units.sym)
    localStorage.setItem("language", prefs.language.sym)
    this.store.dispatch(redux.setPreferences(prefs))
  }
}

export default Controller
