import moment from "moment";
import queryString from "query-string";

import { isSomething, parseDate } from "../common";

import {
  STATUS_OK,
  STATUS_ERROR,
  AUTHENTICATE,
  LOGOUT,
  HISTORY_FETCH,
  HISTORY_CANCEL_EDIT_ENTRY,
  HISTORY_EDIT_ENTRY,
  HISTORY_INVALIDATE,
  SAVE_TIME_DISTANCE,
  SAVE_WEIGHT
} from "./actions";
import { initialState } from "./state";

const handleAuthActions = (state, action) => {
  switch (action.type) {
    case AUTHENTICATE:
      switch (action.status) {
        case STATUS_OK:
          return {
            ...state,
            isFetching: false,
            error: null,
            creds: action.value
          };
        case STATUS_ERROR:
          return {
            ...state,
            isFetching: false,
            error: action.error,
            creds: null
          };
        default:
          return { ...state, isFetching: true, error: null, creds: null };
      }
    case LOGOUT:
      switch (action.status) {
        case STATUS_OK:
          return { ...state, isFetching: false, error: null, creds: null };
        default:
          return state;
      }
    default:
      return state;
  }
};

const handleHistoryActions = (state, action) => {
  switch (action.type) {
    case HISTORY_FETCH:
      switch (action.status) {
        case STATUS_OK:
          return {
            ...state,
            isFetching: false,
            didInvalidate: false,
            data: action.value
          };
        case STATUS_ERROR:
          return {
            ...state,
            isFetching: false,
            didInvalidate: true,
            data: null
          };
        default:
          return { ...state, isFetching: true, didInvalidate: false };
      }
    case HISTORY_CANCEL_EDIT_ENTRY:
      return { ...state, currentlyEditing: null };
    case HISTORY_EDIT_ENTRY:
      return { ...state, currentlyEditing: action.date };
    case HISTORY_INVALIDATE:
      return { ...state, didInvalidate: true };
    case SAVE_TIME_DISTANCE:
      return { ...state, didInvalidate: true };
    case SAVE_WEIGHT:
      return { ...state, didInvalidate: true };
    default:
      return state;
  }
};

export const handleAction = (state, action) => {
  if (!isSomething(state)) {
    /* TODO: I'm not sure whether it is safe to call localStorage here.
         * Potentially loading this is an action that needs to begin
         * immediately *after* initialization. */
    const params = queryString.parse(location.search);
    if (isSomething(params.token)) {
      localStorage.setItem("credentials", params.token[0]);
    }

    var range = null;
    if (isSomething(params.start) && isSomething(params.end)) {
      const start = parseDate(params.start);
      const end = parseDate(params.end);
      if (isSomething(start) && isSomething(end) && start.isBefore(end)) {
        console.log("dates detected: ", start, end);
        range = [start, end];
      }
    }

    return initialState(
      moment().utcOffset(),
      localStorage.getItem("credentials"),
      range,
      null
    );
  }

  return {
    auth: handleAuthActions(state.auth, action),
    history: handleHistoryActions(state.history, action)
  };
};
