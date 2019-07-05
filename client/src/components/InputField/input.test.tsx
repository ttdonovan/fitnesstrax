import { shallow } from "enzyme"
import { Option } from "ld-ambiguity"
import React from "react"

import InputField from "./index"

describe("InputField", () => {
  it("renders", () => {
    const onChange = jest.fn()
    const wrapper = shallow(
      <InputField
        value={"sample-token"}
        classNames={{}}
        onChange={onChange}
        placeholder="placeholder text"
      />,
    )
    expect(wrapper).toMatchSnapshot()
    expect(onChange).not.toHaveBeenCalled()
  })

  it("calls the change handler when an update happens", () => {
    const onChange = jest.fn()
    const wrapper = shallow(
      <InputField
        value={"sample-token"}
        classNames={{}}
        onChange={onChange}
        placeholder="placeholder text"
      />,
    )
    wrapper.simulate("change", { target: { value: "abcdefg" } })
    expect(onChange).toHaveBeenCalledWith("abcdefg")
  })
})
