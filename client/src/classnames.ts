import _ from "lodash/fp"

export type ClassNames = { [_: string]: boolean }
export const classnames = (props: ClassNames): string =>
  _.compose(
    lst => lst.join(" "),
    _.map(pair => pair[0]),
    _.filter(pair => pair[1]),
    _.entries,
  )(props)
