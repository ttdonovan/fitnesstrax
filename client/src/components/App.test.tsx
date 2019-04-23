import { mount } from "enzyme"
import React from "react"
import { Provider } from "react-redux"
import { createStore, applyMiddleware } from "redux"
import thunkMiddleware from "redux-thunk"

import { App } from "./App"
import { handleAction, AppState } from "../state"

const setupStore = () =>
  createStore(handleAction, applyMiddleware(thunkMiddleware))

describe("App", () => {
  it("renders the login view when no credentials are present", () => {
    const wrapper = mount(
      <Provider store={setupStore()}>
        <App creds={null} />
      </Provider>,
    )
    expect(wrapper.find('[id="Home"]').exists()).toBe(false)
    expect(wrapper.find('[id="LoginForm"]').exists()).toBe(true)
  })

  it("renders the home view when credentials are present", () => {
    const wrapper = mount(
      <Provider store={setupStore()}>
        <App creds="some-token" />
      </Provider>,
    )
    expect(wrapper.find('[id="Home"]').exists()).toBe(true)
    expect(wrapper.find('[id="LoginForm"]').exists()).toBe(false)
  })
})
