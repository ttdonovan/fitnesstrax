import { Option } from "ld-ambiguity"
import _ from "lodash/fp"

import { first } from "../common"
import * as i18n from "../i18n"

export class UnitSystem {
  constructor(
    readonly sym: string,
    readonly length: string,
    readonly lengthRepr: i18n.Message,
    readonly mass: string,
    readonly massRepr: i18n.Message,
  ) {}
}

export const SI = new UnitSystem(
  "SI",
  "km",
  i18n.kilometers,
  "kg",
  i18n.kilograms,
)
export const USA = new UnitSystem(
  "USA",
  "miles",
  i18n.miles,
  "lbs",
  i18n.pounds,
)
export const UK = new UnitSystem(
  "UK",
  "miles",
  i18n.miles,
  "stones",
  i18n.stones,
)
export const Canada = new UnitSystem(
  "Canada",
  "km",
  i18n.kilometers,
  "kg",
  i18n.kilograms,
)

export const UnitSystems: Array<UnitSystem> = [SI, USA, UK, Canada]

export const unitsystemFromSymbol = (s: string): Option<UnitSystem> =>
  first(_.filter((lang: UnitSystem): boolean => lang.sym === s)(UnitSystems))
