import { createStore } from "redux"
import Controller from "./controller"
import * as redux from "./redux"

export const setupEnv = () => {
  const store = createStore(redux.rootReducer)
  const controller = new Controller("http://nowhere/", store)
  return {
    store,
    controller,
  }
}
