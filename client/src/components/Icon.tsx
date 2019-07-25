import React from "react"

const Icon: React.SFC<{ path: string }> = ({ path }: { path: string }) => (
  <img src={path} />
)

export default Icon
