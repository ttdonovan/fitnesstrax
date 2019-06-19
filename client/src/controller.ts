import Client from "./client"
import * as redux from "./redux"
import { Range, Record } from "./types"

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
        .then((records: Array<Record>) => {
          console.log("finishing fetchRecords")
          this.store.dispatch(redux.saveRecords(records))
        })
    }
    return new Promise(r => null)
  }
}

export default Controller
