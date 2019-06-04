import { isSomething } from "../common"
/* TODO: complete error handling
 * Likely error handling needs to be a global phenomenon with one error message
 * for the entire app. But it is also possible that some part of the error
 * message has to specify what component the error applies to. Possibly I want
 * a list of error messages, each one tagged with a component.
 */

/*
export class State {
  utcOffset: any
  auth: {
    isFetching: boolean
    error: string | null
    creds: string | null
  }
  history: {
    isFetching: boolean
    didInvalidate: boolean
    lastUpdated: any
    range: any
    data: any
    currentlyEditing: any
  }

  constructor(utcOffset, creds, range, data) {
      this.utcOffset = utcOffset
      this.auth = { isFetching: false, error: null, creds: creds }
      this.history = { isFetching: false, didInvalidate: false, lastUpdated: null, range: range, data: data, currentlyEditing: null }
  }
}
*/

export interface AppState {
  utcOffset: any
  auth: {
    isFetching: boolean
    error: string | null
    creds: string | null
  }
  history: {
    isFetching: boolean
    didInvalidate: boolean
    lastUpdated: any
    range: any
    data: any
    currentlyEditing: any
  }
}

export const initialState = (utcOffset, creds, range, data): AppState => ({
  utcOffset: utcOffset,
  auth: {
    isFetching: false,
    error: null,
    creds: creds,
  },
  history: {
    isFetching: false,
    didInvalidate: false,
    lastUpdated: null,
    range: range,
    data: null,
    currentlyEditing: null,
  },
})

export const shouldFetchHistory = state => {
  if (!isSomething(state.history.data)) {
    return true
  } else if (state.history.isFetching) {
    return false
  } else {
    return state.history.didInvalidate
  }
}

export const getUtcOffset = state => state.utcOffset
export const getRange = state => state.history.range
export const getHistory = state => state.history.data
export const getCurrentlyEditing = state => state.history.currentlyEditing
