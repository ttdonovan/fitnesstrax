import { shallow } from "enzyme"
import React from "react"

import { LoginForm, LoginView } from "./LoginForm"

describe("LoginForm", () => {
  it("renders", () => {
    const onSubmit = jest.fn()
    const wrapper = shallow(<LoginForm onSubmit={onSubmit} token={null} />)

    expect(wrapper).toMatchSnapshot()
    expect(onSubmit).not.toHaveBeenCalled()
  })

  it("submits the token on button press", () => {
    const onSubmit = jest.fn()
    const wrapper = shallow(
      <LoginForm token="sample-token" onSubmit={onSubmit} />,
    )

    const inputField = wrapper.find("InputField")
    const loginButton = wrapper.find('button[name="LoginButton"]')
    loginButton.simulate("click")

    expect(onSubmit).toHaveBeenCalledWith({ token: "sample-token" })
  })
})
