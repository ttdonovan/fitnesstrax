import { mount } from "enzyme"
import moment from "moment"
import React from "react"
import { Provider } from "react-redux"

import { DateTimeTz, Date } from "../../datetimetz"
import { setupEnv } from "../../testSetup"
import { Range } from "../../types"
import HistoryView from "./index"

describe("HistoryView", () => {
  it("renders when there is no history", () => {
    const { store, controller } = setupEnv()
    controller.fetchRecords = jest.fn()

    const wrapper = mount(
      <Provider store={store}>
        <HistoryView controller={controller} />
      </Provider>,
    )
    expect(wrapper.find("Range").prop("range")).toEqual(
      new Range(new Date(2017, 10, 23), new Date(2017, 10, 29)),
    )
    expect(wrapper.find("DailyEntry").length).toEqual(7)
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
