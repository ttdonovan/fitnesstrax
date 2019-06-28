import { createStore } from "redux"
import { IANAZone } from "luxon"

import Controller from "./controller"
import * as redux from "./redux"
import { English } from "./i18n"
import { USA, UserPreferences } from "./settings"

export const setupEnv = () => {
  const store = createStore(redux.rootReducer)
  const controller = new Controller("http://nowhere/", store)
  return {
    store,
    controller,
  }
}

export const standardPreferences = () =>
  new UserPreferences(IANAZone.create("America/New_York"), USA, English)
