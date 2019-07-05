import { mount } from "enzyme"
import { Option } from "ld-ambiguity"
import React from "react"

import { parseNumber } from "../../parsers"
import ValidatedInputField from "./index"

describe("ValidatedInputField", () => {
  it("renders", () => {
    const onChange = jest.fn()
    const wrapper = mount(
      <ValidatedInputField
        value={Option.Some(15)}
        placeholder="validated input field"
        render={(val: number): string => val.toString()}
        parse={parseNumber}
        onChange={onChange}
      />,
    )
    expect(wrapper).toMatchSnapshot()
    expect(onChange).not.toHaveBeenCalled()
    expect(wrapper.find("input").prop("value")).toEqual("15")
  })

  it("handles valid updates", () => {
    const onChange = jest.fn()
    const wrapper = mount(
      <ValidatedInputField
        value={Option.Some(15)}
        placeholder="validated input field"
        render={(val: number): string => val.toString()}
        parse={parseNumber}
        onChange={onChange}
      />,
    )
    wrapper.find("input").simulate("change", { target: { value: "16" } })
    expect(wrapper).toMatchSnapshot()
    expect(onChange).toHaveBeenCalledWith(Option.Some(16))
    expect(wrapper.find("input").prop("value")).toEqual("16")
    expect(wrapper.find("input").prop("className")).toEqual("valid")
  })

  it("handles invalid updates", () => {
    const onChange = jest.fn()
    const wrapper = mount(
      <ValidatedInputField
        value={Option.Some(15)}
        placeholder="validated input field"
        render={(val: number): string => val.toString()}
        parse={parseNumber}
        onChange={onChange}
      />,
    )
    wrapper.find("input").simulate("change", { target: { value: "abcdefg" } })
    expect(wrapper).toMatchSnapshot()
    expect(onChange).not.toHaveBeenCalled()
    expect(wrapper.find("input").prop("value")).toEqual("abcdefg")
    expect(wrapper.find("input").prop("className")).toEqual("invalid")
  })
})
