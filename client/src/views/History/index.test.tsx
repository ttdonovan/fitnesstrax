import { mount } from "enzyme"
import moment from "moment"
import React from "react"
import { Provider } from "react-redux"

import { setupEnv } from "../../testSetup"
import HistoryView from "./index"

describe("HistoryView", () => {
  xit("renders when there is no history", () => {
    const { store, controller } = setupEnv()

    const wrapper = mount(
      <Provider store={store}>
        <HistoryView
          controller={controller}
          range={{
            start: moment("2017-10-23T22:09:00Z"),
            end: moment("2018-11-12T18:30:00Z"),
          }}
        />
      </Provider>,
    )

    console.log(wrapper.debug())
    expect(wrapper).toMatchSnapshot()
  })

  xit("renders all of the elements of a weights-only history", () => {
    /*
    const { store, controller } = setupEnv()
    store.dispatch(

    const wrapper = mount(
      <Provider store={store}>
        <HistoryView controller={controller} />
      </Provider>,
    )

    console.log(wrapper.debug())
    expect(wrapper).toMatchSnapshot()
  */
  })

  xit("renders reasonably with duplicate weight entries", () => {})

  xit("renders all of the elements of a timedistance-only history", () => {})

  xit("renders all of the elements of a timedistance-only history", () => {})
})
