import Client from "./client"
import * as redux from "./redux"
import { Range } from "./types"

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

  fetchRecords = (range: Range): Promise<void> =>
    this.client
      .fetchHistory(
        redux.getAuthToken(this.store.getState()),
        range.start,
        range.end,
      )
      .then(records => {
        console.log("finishing fetchRecords")
        this.store.dispatch(redux.saveRecords(records))
      })
}

export default Controller
