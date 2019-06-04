import { AppState } from "./state"

export { handleAction } from "./reducers"
export { initialState, AppState } from "./state"

export const getCredentials = (state: AppState): string | null =>
  state.auth.creds
