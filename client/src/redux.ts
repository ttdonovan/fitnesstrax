import { Option, Result } from "ld-ambiguity"
import _ from "lodash/fp"
import { DateTime, IANAZone } from "luxon"
import moment from "moment-timezone"
import queryString from "query-string"
import { Store } from "redux"

import * as client from "./client"
import { isSomething } from "./common"
import { Range, Record, RecordTypes } from "./types"
import { English, Language, languageFromSymbol } from "./i18n"
import { Date, DateTimeTz } from "./datetimetz"
import {
  UserPreferences,
  UnitSystem,
  unitsystemFromSymbol,
  SI,
} from "./settings"

export type Views = "History" | "Preferences"

export interface AppState {
  creds: string | null
  currentView: Views
  error: string | null
  history: Map<string, Record<RecordTypes>>
  preferences: UserPreferences
  utcOffset: number
  range: Range<Date>
  /* TODO: I actually want a real live timezone entry here, but I don't know how to get the current timezone. Figure it out when I have internet again. */
}

export const getAuthToken = (state: AppState): string | null => state.creds
export const getCurrentView = (state: AppState): Views => state.currentView
export const getError = (state: AppState): string | null => state.error
export const getHistory = (state: AppState): Array<Record<RecordTypes>> =>
  _.compose(
    _.map(
      (pair: [string, Record<RecordTypes>]): Record<RecordTypes> => pair[1],
    ),
    _.entries,
  )(state.history)
export const getRange = (state: AppState) => state.range
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

interface SetRangeAction {
  type: "SET_RANGE"
  range: Range<Date>
}
export const setRange = (range: Range<Date>): SetRangeAction => ({
  type: "SET_RANGE",
  range,
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
  | SetRangeAction
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

  /* Need a useful lookup function for this */
  if (isSomething(params.token)) {
    if (typeof params.token === "string") {
      localStorage.setItem("credentials", params.token)
    } else {
      localStorage.setItem("credentials", params.token[0])
    }
  }

  let start = new DateTimeTz(DateTime.local().minus({ days: 7 })).toDate()
  if (isSomething(params.start)) {
    if (typeof params.start === "string") {
      start = Date.fromString(params.start).unwrap()
    } else {
      start = Date.fromString(params.start[0]).unwrap()
    }
  }

  let end = new DateTimeTz(DateTime.local()).toDate()
  if (isSomething(params.end)) {
    if (typeof params.end === "string") {
      end = Date.fromString(params.end).unwrap()
    } else {
      end = Date.fromString(params.end[0]).unwrap()
    }
  }

  return {
    creds: localStorage.getItem("credentials"),
    currentView: "History",
    error: null,
    history: new Map(),
    preferences: loadPreferences(),
    range: new Range(start, end),
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
      error: action.msg,
    }
  } else if (action.type === "SET_PREFERENCES") {
    state_ = { ...state_, preferences: action.prefs }
  } else if (action.type === "SET_RANGE") {
    state_ = { ...state_, range: action.range }
  } else if (action.type === "SET_VIEW") {
    state_ = { ...state_, currentView: action.view }
  }

  return state_
}

export type AppStore = Store<AppState, Actions>
