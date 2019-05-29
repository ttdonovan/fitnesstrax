import Client from "./client"
import * as redux from "./redux"

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
}

export default Controller
