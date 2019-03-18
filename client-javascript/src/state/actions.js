import { getCredentials, getRange, getUtcOffset, shouldFetchHistory } from './state'
import { authenticate } from '../auth'
import { fetchHistory, historyFromRecords, saveTimeDistance, saveWeight } from '../client'
import { isSomething } from '../common'

export const STATUS_OK      = 'SUCCESS'
export const STATUS_ERROR   = 'ERROR'

export const AUTHENTICATE = 'AUTHENTICATE'
export const LOGOUT       = 'LOGOUT'

export const HISTORY_FETCH              = 'HISTORY_FETCH'
export const HISTORY_CANCEL_EDIT_ENTRY  = 'HISTORY_CANCEL_EDIT_ENTRY'
export const HISTORY_EDIT_ENTRY         = 'HISTORY_EDIT_ENTRY'
export const HISTORY_INVALIDATE         = 'HISTORY_INVALIDATE'

export const SAVE_TIME_DISTANCE         = 'SAVE_TIME_DISTANCE'
export const SAVE_WEIGHT                = 'SAVE_WEIGHT'


const asyncAction = (actionType, status, value) =>
    isSomething(status)
        ? ((status == STATUS_OK)
            ? { type: actionType, status: status, value: value }
            : { type: actionType, status: status, error: value })
        : { type: actionType }


const authAction = (status, val) => asyncAction(AUTHENTICATE, status, val)

export const runAuthentication = (token) => {
    return function (dispatch) {
        dispatch(authAction())

        localStorage.setItem('credentials', token)
        return dispatch(authAction(STATUS_OK, token))
    }
}

const logoutAction = (status) => asyncAction(LOGOUT, status, null)

export const runLogout = () => {
    return function (dispatch) {
        dispatch(logoutAction())
        localStorage.removeItem('credentials')
        return dispatch(logoutAction(STATUS_OK, null))
    }
}


const fetchHistoryAction = (status, val) => asyncAction(HISTORY_FETCH, status, val)

export const runFetchHistory = () => {
    return (dispatch, getState) => {
        const st = getState()
        const [startDate, endDate] = getRange(st) ? getRange(st) : [null, null]
        if (isSomething(getCredentials(st)) && shouldFetchHistory(st)) {
            dispatch(fetchHistoryAction())

            return fetchHistory(window.location.origin, getCredentials(st), startDate, endDate)
                               .then((res) => { if (res.err) {
                                                    return dispatch(fetchHistoryAction(STATUS_ERROR, res.err))
                                              } else {
                                                  var history = historyFromRecords(getUtcOffset(st), res.value)
                                                  return dispatch(fetchHistoryAction(STATUS_OK, history))
                                              }})
        }
    }
}

export const cancelEditEntry = () => ({type: HISTORY_CANCEL_EDIT_ENTRY})
export const editEntry = (date) => ({type: HISTORY_EDIT_ENTRY, date: date})
export const invalidateHistory = () => ({type: HISTORY_INVALIDATE})


const saveWeightAction = (status, val) => asyncAction(SAVE_WEIGHT, status, val)

export const runSaveWeight = (weightSample) => {
    return (dispatch, getState) => {
        const st = getState()
        dispatch(invalidateHistory())
        dispatch(saveWeightAction())
        return saveWeight(window.location.origin, getCredentials(st), weightSample)
                         .then((res) => { if (res.err) {
                                            return dispatch(saveWeightAction(STATUS_ERROR, res.err))
                                          } else {
                                            return dispatch(saveWeightAction(STATUS_OK, res.value))
                                          }})
    }
}

const saveTimeDistanceAction = (status, val) => asyncAction(SAVE_TIME_DISTANCE, status, val)

export const runSaveTimeDistance = (timeDistanceSample) => {
    return (dispatch, getState) => {
        const st = getState()
        dispatch(invalidateHistory())
        dispatch(saveTimeDistanceAction())
        return saveTimeDistance(window.location.origin, getCredentials(st), timeDistanceSample)
                               .then((res) => { if (res.err) {
                                                    return dispatch(saveTimeDistanceAction(STATUS_ERROR, res.err))
                                                } else {
                                                    return dispatch(saveTimeDistanceAction(STATUS_OK, res.value))
                                                }})
    }
}

