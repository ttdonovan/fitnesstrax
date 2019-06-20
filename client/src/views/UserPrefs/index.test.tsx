import React from "react"
import { shallow } from "enzyme"
import { IANAZone } from "luxon"

import { English, SI } from "../../settings"
import { UserPreferences } from "../../userPrefs"
import UserPreferenceView from "./index"

describe("UserPreferencesView", () => {
  it("renders with default values", () => {
    const prefs = new UserPreferences(IANAZone.create("UTC"), SI, English)
    const wrapper = shallow(
      <UserPreferenceView prefs={prefs} onSave={() => null} />,
    )
    expect(wrapper).toMatchSnapshot()
  })
})
