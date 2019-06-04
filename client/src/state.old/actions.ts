import { getCredentials } from "./index"
import { getRange, getUtcOffset, shouldFetchHistory } from "./state"
import { authenticate } from "../auth"
import {
  //fetchHistory,
  //historyFromRecords,
  saveTimeDistance,
  saveWeight,
} from "../client"
import { isSomething } from "../common"
import Result from "../result"

export const STATUS_OK = "SUCCESS"
export const STATUS_ERROR = "ERROR"

export const AUTHENTICATE = "AUTHENTICATE"
export const LOGOUT = "LOGOUT"

export const HISTORY_FETCH = "HISTORY_FETCH"
export const HISTORY_CANCEL_EDIT_ENTRY = "HISTORY_CANCEL_EDIT_ENTRY"
export const HISTORY_EDIT_ENTRY = "HISTORY_EDIT_ENTRY"
export const HISTORY_INVALIDATE = "HISTORY_INVALIDATE"

export const SAVE_TIME_DISTANCE = "SAVE_TIME_DISTANCE"
export const SAVE_WEIGHT = "SAVE_WEIGHT"

const asyncAction = (actionType, status, value) =>
  isSomething(status)
    ? status == STATUS_OK
      ? { type: actionType, status: status, value: value }
      : { type: actionType, status: status, error: value }
    : { type: actionType }

const authAction = (status, val) => asyncAction(AUTHENTICATE, status, val)

export const runAuthentication = token => {
  return function(dispatch) {
    dispatch(authAction(null, null))

    localStorage.setItem("credentials", token)
    return dispatch(authAction(STATUS_OK, token))
  }
}

const logoutAction = status => asyncAction(LOGOUT, status, null)

export const runLogout = () => {
  return function(dispatch) {
    dispatch(logoutAction(null))
    localStorage.removeItem("credentials")
    return dispatch(logoutAction(STATUS_OK))
  }
}

/*
const fetchHistoryAction = (status, val) =>
  asyncAction(HISTORY_FETCH, status, val)
     */

/*
export const runFetchHistory = () => {
  return (dispatch, getState) => {
    const st = getState()
    const [startDate, endDate] = getRange(st) ? getRange(st) : [null, null]
    if (isSomething(getCredentials(st)) && shouldFetchHistory(st)) {
      dispatch(fetchHistoryAction(null, null))

      return fetchHistory(
        window.location.origin,
        getCredentials(st),
        startDate,
        endDate,
      ).then(res => {
        res
          .map(ok => {
            var history = historyFromRecords(getUtcOffset(st), ok)
            dispatch(fetchHistoryAction(STATUS_OK, history))
          })
          .map_err(err => dispatch(fetchHistoryAction(STATUS_ERROR, err)))
      })
    }
  }
}
     */

export const cancelEditEntry = () => ({ type: HISTORY_CANCEL_EDIT_ENTRY })
export const editEntry = date => ({ type: HISTORY_EDIT_ENTRY, date: date })
export const invalidateHistory = () => ({ type: HISTORY_INVALIDATE })

const saveWeightAction = (status, val) => asyncAction(SAVE_WEIGHT, status, val)

export const runSaveWeight = weightSample => {
  return (dispatch, getState) => {
    const st = getState()
    dispatch(invalidateHistory())
    dispatch(saveWeightAction(null, null))
    return saveWeight(
      window.location.origin,
      getCredentials(st),
      weightSample,
    ).then(res => {
      res
        .map(ok => dispatch(saveWeightAction(STATUS_OK, ok)))
        .map_err(err => dispatch(saveWeightAction(STATUS_ERROR, err)))
    })
  }
}

const saveTimeDistanceAction = (status, val) =>
  asyncAction(SAVE_TIME_DISTANCE, status, val)

export const runSaveTimeDistance = timeDistanceSample => {
  return (dispatch, getState) => {
    const st = getState()
    dispatch(invalidateHistory())
    dispatch(saveTimeDistanceAction(null, null))
    return saveTimeDistance(
      window.location.origin,
      getCredentials(st),
      timeDistanceSample,
    ).then(res => {
      res
        .map(ok => dispatch(saveTimeDistanceAction(STATUS_OK, ok)))
        .map_err(err => dispatch(saveTimeDistanceAction(STATUS_ERROR, err)))
    })
  }
}
