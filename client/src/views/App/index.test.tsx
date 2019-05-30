import { mount } from "enzyme"
import React from "react"
import { Provider } from "react-redux"
import { createStore } from "redux"

import { setupEnv } from "../../testSetup"
import * as redux from "../../redux"
import AppView from "./index"

describe("App", () => {
  it("renders the login view when no credentials are present", () => {
    const { store, controller } = setupEnv()

    const wrapper = mount(
      <Provider store={store}>
        <AppView controller={controller} />
      </Provider>,
    )
    expect(wrapper.find('[id="Home"]').exists()).toBe(false)
    expect(wrapper.find('[id="LoginForm"]').exists()).toBe(true)
  })

  it("renders the home view when credentials are present", () => {
    const { store, controller } = setupEnv()
    store.dispatch(redux.setAuthToken("abcdefg"))

    const wrapper = mount(
      <Provider store={store}>
        <AppView controller={controller} />
      </Provider>,
    )
    expect(wrapper.find('[id="Home"]').exists()).toBe(true)
    expect(wrapper.find('[id="LoginForm"]').exists()).toBe(false)
  })
})
