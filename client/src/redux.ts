import moment from "moment-timezone"
import queryString from "query-string"
import { Store } from "redux"
import _ from "lodash/fp"

import * as client from "./client"
import { isSomething, parseDate } from "./common"
import { Range, Record } from "./types"

export interface AppState {
  creds: string | null
  currentlyEditing: Record | null
  error: { msg: string; timeout: Promise<{}> } | null
  history: Map<string, Record>
  range: Range
  utcOffset: number
  /* TODO: I actually want a real live timezone entry here, but I don't know how to get the current timezone. Figure it out when I have internet again. */
}

export const getAuthToken = (state: AppState): string | null => state.creds
export const getCurrentlyEditing = (state: AppState): Record | null =>
  state.currentlyEditing
export const getHistory = (state: AppState): Map<string, Record> =>
  state.history
export const getRange = (state: AppState) => state.range
export const getRecord = (state: AppState): Map<string, Record> => state.history
export const getUtcOffset = (state: AppState): number => state.utcOffset

interface ClearErrorAction {
  type: "CLEAR_ERROR"
}

export const clearError = (): ClearErrorAction => ({ type: "CLEAR_ERROR" })

interface SaveRecordsAction {
  type: "SAVE_RECORDS"
  records: Array<Record>
}

export const saveRecords = (records: Array<Record>): SaveRecordsAction => ({
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

export type Actions =
  | ClearErrorAction
  | SaveRecordsAction
  | SetAuthTokenAction
  | SetErrorAction

export const initialState = (): AppState => {
  const params = queryString.parse(location.search)
  if (isSomething(params.token)) {
    localStorage.setItem("credentials", params.token[0])
  }

  var range = null
  if (isSomething(params.start) && isSomething(params.end)) {
    const start = parseDate(params.start)
    const end = parseDate(params.end)
    if (isSomething(start) && isSomething(end) && start.isBefore(end)) {
      range = [start, end]
    }
  }

  /* TODO: use the timezone in localStorage, defaulting to moment's calculation only if necessary */
  return {
    creds: localStorage.getItem("credentials"),
    currentlyEditing: null,
    error: null,
    history: new Map(),
    range,
    utcOffset: moment().utcOffset(),
  }
}

export const rootReducer = (
  state: AppState | undefined,
  action: Actions | undefined,
): AppState => {
  let state_ = state ? state : initialState()

  if (!action) return state

  if (action.type === "CLEAR_ERROR") {
    state_ = { ...state_, error: null }
  } else if (action.type === "SAVE_RECORDS") {
    const history = new Map(state.history)
    _.forEach((record: Record) => history.set(record.id, record))(
      action.records,
    )
    state_ = { ...state, history }
  } else if (action.type === "SET_AUTH_TOKEN") {
    localStorage.setItem("credentials", action.token)
    state_ = { ...state, creds: action.token }
  } else if (action.type === "SET_ERROR") {
    state_ = {
      ...state_,
      error: {
        msg: action.msg,
        timeout: new Promise(r => setTimeout(r, 5 * 1000)).then(
          this.store.dispatch(clearError()),
        ),
      },
    }
  }

  return state_
}

export type AppStore = Store<AppState, Actions>
