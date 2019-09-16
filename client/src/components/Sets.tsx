import { Option, Result, sequenceResult } from "ld-ambiguity"
import _ from "lodash/fp"
import * as math from "mathjs"
import React from "react"

import { sequenceOption } from "../common"
import * as i18n from "../i18n"
import { parseNumber } from "../parsers"
import { UserPreferences } from "../settings"
import ValidatedInputField from "./ValidatedInputField"

interface ViewProps {
  sets: Array<number>
}

export const SetsView: React.SFC<ViewProps> = ({ sets }) => (
  <React.Fragment>{sets.join(" ")}</React.Fragment>
)

interface EditProps {
  sets: Array<number>
  onChange: (_: Option<Array<number>>) => void
  prefs: UserPreferences
}

export const SetsEdit: React.SFC<EditProps> = ({ sets, onChange, prefs }) => (
  <React.Fragment>
    <ValidatedInputField
      value={Option.Some(sets)}
      placeholder={"enter sets"}
      render={sets => sets.join(" ")}
      parse={(str: string): Result<Option<Array<number>>, string> => {
        if (str === "") return Result.Ok(Option.Some([]))
        const r: Result<Array<Option<number>>, string> = sequenceResult(
          _.map(parseNumber)(str.split(" ")),
        )
        return r
          .map(vals => sequenceOption(vals))
          .andThen(v => (v.isSome() ? Result.Ok(v) : Result.Err("no values")))
      }}
      onChange={inp => onChange(inp)}
    />
  </React.Fragment>
)
