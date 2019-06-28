import { createStore } from "redux"
import { IANAZone } from "luxon"

import Controller from "./controller"
import * as redux from "./redux"
import { English } from "./i18n"
import { USA, UserPreferences } from "./settings"
import { Date } from "./datetimetz"
import { Range } from "./types"

export const setupEnv = () => {
  const testRange = new Range(
    Date.fromString("2017-10-23").unwrap(),
    Date.fromString("2017-10-29").unwrap(),
  )
  const store = createStore(redux.rootReducer)
  store.dispatch(redux.setRange(testRange))

  const controller = new Controller("http://nowhere/", store)
  return {
    store,
    controller,
  }
}

export const standardPreferences = () =>
  new UserPreferences(IANAZone.create("America/New_York"), USA, English)
