import React from "react"
import { shallow } from "enzyme"

import Navigation from "./index"

describe("Navigation", () => {
  it("renders", () => {
    const setView = jest.fn()
    const wrapper = shallow(<Navigation view="History" setView={setView} />)
    console.log(wrapper.debug())
    expect(wrapper).toMatchSnapshot()
  })
})
