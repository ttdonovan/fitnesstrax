import { Option } from "ld-ambiguity"
import { Duration } from "luxon"
import React from "react"

import { classnames, ClassNames } from "../classnames"
import { parseDuration } from "../parsers"
import { UserPreferences } from "../settings"
import * as i18n from "../i18n"
import ValidatedInputField from "./ValidatedInputField"

export const renderDuration = (d: Duration): string => {
  if (d.as("hours") >= 1) return d.toFormat("h:mm:ss")
  else if (d.as("minutes") >= 1) return d.toFormat("m:ss")
  else return d.toFormat("s")
}

interface ViewProps {
  duration: Duration
}

export const DurationView: React.SFC<ViewProps> = ({ duration }: ViewProps) => (
  <React.Fragment>{duration.toFormat("h:mm:ss")}</React.Fragment>
)

interface EditProps {
  duration: Option<Duration>
  onChange: (_: Option<Duration>) => void
  prefs: UserPreferences
}

export const DurationEdit: React.SFC<EditProps> = ({
  duration,
  onChange,
  prefs,
}) => (
  <ValidatedInputField
    value={duration}
    placeholder={i18n.DurationEntryPlaceholder.tr(prefs.language)}
    render={d => renderDuration(d)}
    parse={str => parseDuration(str)}
    onChange={inp => onChange(inp)}
  />
)

export default DurationView
