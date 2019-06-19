import moment from "moment-timezone"
import queryString from "query-string"
import { Store } from "redux"
import _ from "lodash/fp"

import * as client from "./client"
import { isSomething } from "./common"
import { Range, Record } from "./types"

export type Views = "History" | "Preferences"

export interface AppState {
  creds: string | null
  currentView: Views
  currentlyEditing: Record | null
  error: { msg: string; timeout: Promise<{}> } | null
  history: Map<string, Record>
  utcOffset: number
  /* TODO: I actually want a real live timezone entry here, but I don't know how to get the current timezone. Figure it out when I have internet again. */
}

export const getAuthToken = (state: AppState): string | null => state.creds
export const getCurrentView = (state: AppState): Views => state.currentView
export const getCurrentlyEditing = (state: AppState): Record | null =>
  state.currentlyEditing
export const getHistory = (state: AppState): Array<Record> =>
  _.compose(
    _.map((pair: [string, Record]): Record => pair[1]),
    _.entries,
  )(state.history)
//export const getRange = (state: AppState) => state.range
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

interface SetView {
  type: "SET_VIEW"
  view: Views
}

export const setView = (view: Views): SetView => ({
  type: "SET_VIEW",
  view,
})

export type Actions =
  | ClearErrorAction
  | SaveRecordsAction
  | SetAuthTokenAction
  | SetErrorAction
  | SetView

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

  /* TODO: use the timezone in localStorage, defaulting to moment's calculation only if necessary */
  return {
    creds: localStorage.getItem("credentials"),
    currentView: "History",
    currentlyEditing: null,
    error: null,
    history: new Map(),
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
    _.forEach((record: Record) => history.set(record.id, record))(
      action.records,
    )
    state_ = { ...state_, history }
  } else if (action.type === "SET_AUTH_TOKEN") {
    if (action.token) localStorage.setItem("credentials", action.token)
    else localStorage.deleteItem("credentials")
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
  } else if (action.type === "SET_VIEW") {
    state_ = { ...state_, currentView: action.view }
  }

  return state_
}

export type AppStore = Store<AppState, Actions>
