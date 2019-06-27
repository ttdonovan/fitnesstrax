import { Option } from "ld-ambiguity"
import _ from "lodash/fp"
import { IANAZone } from "luxon"
import moment from "moment-timezone"
import queryString from "query-string"
import { Store } from "redux"

import * as client from "./client"
import { isSomething } from "./common"
import { Range, Record, RecordTypes } from "./types"
import {
  UnitSystem,
  unitsystemFromSymbol,
  English,
  SI,
  Language,
  languageFromSymbol,
} from "./settings"
import { UserPreferences } from "./userPrefs"

export type Views = "History" | "Preferences"

export interface AppState {
  creds: string | null
  currentView: Views
  error: { msg: string; timeout: Promise<{}> } | null
  history: Map<string, Record<RecordTypes>>
  preferences: UserPreferences
  utcOffset: number
  /* TODO: I actually want a real live timezone entry here, but I don't know how to get the current timezone. Figure it out when I have internet again. */
}

export const getAuthToken = (state: AppState): string | null => state.creds
export const getCurrentView = (state: AppState): Views => state.currentView
export const getHistory = (state: AppState): Array<Record<RecordTypes>> =>
  _.compose(
    _.map(
      (pair: [string, Record<RecordTypes>]): Record<RecordTypes> => pair[1],
    ),
    _.entries,
  )(state.history)
//export const getRange = (state: AppState) => state.range
export const getPreferences = (state: AppState): UserPreferences =>
  state.preferences
export const getRecord = (state: AppState): Map<string, Record<RecordTypes>> =>
  state.history
export const getUtcOffset = (state: AppState): number => state.utcOffset

interface ClearErrorAction {
  type: "CLEAR_ERROR"
}

export const clearError = (): ClearErrorAction => ({ type: "CLEAR_ERROR" })

interface SaveRecordsAction {
  type: "SAVE_RECORDS"
  records: Array<Record<RecordTypes>>
}

export const saveRecords = (
  records: Array<Record<RecordTypes>>,
): SaveRecordsAction => ({
  type: "SAVE_RECORDS",
  records,
})

interface SetAuthTokenAction {
  type: "SET_AUTH_TOKEN"
  token: string | null
}

export const setAuthToken = (token: string): SetAuthTokenAction => ({
  type: "SET_AUTH_TOKEN",
  token,
})

export const clearAuthToken = (): SetAuthTokenAction => ({
  type: "SET_AUTH_TOKEN",
  token: null,
})

interface SetErrorAction {
  type: "SET_ERROR"
  msg: string
}

export const setError = (msg: string): SetErrorAction => ({
  type: "SET_ERROR",
  msg,
})

interface SetPreferencesAction {
  type: "SET_PREFERENCES"
  prefs: UserPreferences
}

export const setPreferences = (
  prefs: UserPreferences,
): SetPreferencesAction => ({
  type: "SET_PREFERENCES",
  prefs,
})

interface SetViewAction {
  type: "SET_VIEW"
  view: Views
}

export const setView = (view: Views): SetViewAction => ({
  type: "SET_VIEW",
  view,
})

export type Actions =
  | ClearErrorAction
  | SaveRecordsAction
  | SetAuthTokenAction
  | SetErrorAction
  | SetPreferencesAction
  | SetViewAction

const loadPreferences = (): UserPreferences => {
  const storedTimezone = localStorage.getItem("timezone")
    ? IANAZone.create(localStorage.getItem("timezone") || "UTC")
    : IANAZone.create("UTC")
  const timezone = storedTimezone.isValid
    ? storedTimezone
    : IANAZone.create("UTC")
  const units = unitsystemFromSymbol(localStorage.getItem("units") || "").or(SI)
  const language = languageFromSymbol(
    localStorage.getItem("language") || "",
  ).or(English)

  return new UserPreferences(timezone, units, language)
}

export const initialState = (): AppState => {
  const params = queryString.parse(location.search)
  if (isSomething(params.token)) {
    if (isSomething((<Array<string>>params.token)[0])) {
      localStorage.setItem("credentials", (<Array<string>>params.token)[0])
    }
  }

  /*
  var range = null
  if (isSomething(params.start) && isSomething(params.end)) {
    const start = parseDate(params.start)
    const end = parseDate(params.end)
    if (isSomething(start) && isSomething(end) && start.isBefore(end)) {
      range = [start, end]
    }
  }
     */

  return {
    creds: localStorage.getItem("credentials"),
    currentView: "History",
    error: null,
    history: new Map(),
    preferences: loadPreferences(),
    //range,
    utcOffset: moment().utcOffset(),
  }
}

export const rootReducer = (
  state: AppState | undefined,
  action: Actions | undefined,
): AppState => {
  let state_ = state ? state : initialState()

  if (!action) return state_

  if (action.type === "CLEAR_ERROR") {
    state_ = { ...state_, error: null }
  } else if (action.type === "SAVE_RECORDS") {
    const history = new Map(state_.history)
    _.forEach((record: Record<RecordTypes>) => history.set(record.id, record))(
      action.records,
    )
    state_ = { ...state_, history }
  } else if (action.type === "SET_AUTH_TOKEN") {
    state_ = { ...state_, creds: action.token }
  } else if (action.type === "SET_ERROR") {
    state_ = {
      ...state_,
      error: {
        msg: action.msg,
        timeout: new Promise(r => setTimeout(r, 5 * 1000))
          .then
          /* I want to set a timeout that clears the error, but I don't know how to write the dispatch here */
          //this.store.dispatch(clearError()),
          (),
      },
    }
  } else if (action.type === "SET_PREFERENCES") {
    state_ = { ...state_, preferences: action.prefs }
  } else if (action.type === "SET_VIEW") {
    state_ = { ...state_, currentView: action.view }
  }

  return state_
}

export type AppStore = Store<AppState, Actions>
