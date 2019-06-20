import React from "react"
import { shallow } from "enzyme"

import { standardPreferences } from "../../testSetup"
import Navigation from "./index"

describe("Navigation", () => {
  it("renders", () => {
    const setView = jest.fn()
    const wrapper = shallow(
      <Navigation
        view="History"
        setView={setView}
        prefs={standardPreferences()}
      />,
    )
    expect(wrapper).toMatchSnapshot()
  })
})
