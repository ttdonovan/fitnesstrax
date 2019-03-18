import { isSomething } from '../common'
/* TODO: complete error handling
 * Likely error handling needs to be a global phenomenon with one error message
 * for the entire app. But it is also possible that some part of the error
 * message has to specify what component the error applies to. Possibly I want
 * a list of error messages, each one tagged with a component.
 */
export const initialState = (utcOffset, creds, range, data) => (
    { utcOffset: utcOffset
    , auth: { isFetching: false
            , error: null
            , creds: creds
            }
    , history: { isFetching: false
               , didInvalidate: false
               , lastUpdated: null
               , range: range
               , data: null
               , currentlyEditing: null
               }
    })


export const getCredentials = (state) => state.auth.creds

export const shouldFetchHistory = (state) => { if (! isSomething(state.history.data)) {
                                                    return true
                                               } else if (state.history.isFetching) {
                                                    return false
                                               } else {
                                                    return state.history.didInvalidate
                                               }
                                             }

export const getUtcOffset = (state) => state.utcOffset
export const getRange = (state) => state.history.range
export const getHistory = (state) => state.history.data
export const getCurrentlyEditing = (state) => state.history.currentlyEditing

