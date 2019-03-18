import React from "react"
import { intercalate, sum } from "../common"

const setsFieldStyle = { display: "inline", padding: 1, margin: 0 }

export const SetRepRow = ({ record }: { record: any }) => (
  <tr key={record.date}>
    <td>{record.activity}</td>
    <td>
      <input
        className="form-control"
        style={setsFieldStyle}
        value={intercalate(record.sets, " ")}
      />
    </td>
    <td>{sum(record.sets)}</td>
  </tr>
)
