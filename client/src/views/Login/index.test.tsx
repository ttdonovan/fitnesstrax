import { shallow } from "enzyme"
import React from "react"
import { createStore } from "redux"

import Controller from "../../controller"
import Option from "../../option"
import * as redux from "../../redux"
import { standardPreferences } from "../../testSetup"
import LoginView from "./index"

const mockAuthenticate = jest.fn()

describe("LoginView", () => {
  beforeEach(() => {
    mockAuthenticate.mockReset()
  })

  it("renders", () => {
    const store = createStore(redux.rootReducer)
    const controller = new Controller("http://nowhere/", store)
    controller.authenticate = mockAuthenticate

    const wrapper = shallow(
      <LoginView
        controller={controller}
        token={Option.None()}
        prefs={standardPreferences()}
      />,
    )

    expect(wrapper).toMatchSnapshot()
    expect(mockAuthenticate).not.toHaveBeenCalled()
  })

  it("submits the token on button press", () => {
    const store = createStore(redux.rootReducer)
    const controller = new Controller("http://nowhere/", store)
    controller.authenticate = mockAuthenticate

    const wrapper = shallow(
      <LoginView
        controller={controller}
        token={Option.Some("sample-token")}
        prefs={standardPreferences()}
      />,
    )

    const inputField = wrapper.find("InputField")
    const loginButton = wrapper.find('button[name="LoginButton"]')
    loginButton.simulate("click")

    expect(mockAuthenticate).toHaveBeenCalledWith("sample-token")
  })
})
