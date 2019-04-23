import React from "react"
import { shallow } from "enzyme"

import InputField from "./InputField"

describe("InputField", () => {
  it("renders", () => {
    const onChange = jest.fn()
    const wrapper = shallow(
      <InputField value="sample-token" classNames={[]} onChange={onChange} />,
    )
    expect(wrapper).toMatchSnapshot()
    expect(onChange).not.toHaveBeenCalled()
  })
})
