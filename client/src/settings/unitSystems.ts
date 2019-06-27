import { Option } from "ld-ambiguity"
import _ from "lodash/fp"

import { first } from "../common"
import * as msgs from "../translations"

export class UnitSystem {
  constructor(
    readonly sym: string,
    readonly length: string,
    readonly lengthRepr: msgs.Message,
    readonly mass: string,
    readonly massRepr: msgs.Message,
  ) {}
}

export const SI = new UnitSystem(
  "SI",
  "km",
  msgs.kilometers,
  "kg",
  msgs.kilograms,
)
export const USA = new UnitSystem(
  "USA",
  "miles",
  msgs.miles,
  "lbs",
  msgs.pounds,
)
export const UK = new UnitSystem(
  "UK",
  "miles",
  msgs.miles,
  "stones",
  msgs.stones,
)
export const Canada = new UnitSystem(
  "Canada",
  "km",
  msgs.kilometers,
  "kg",
  msgs.kilograms,
)

export const UnitSystems: Array<UnitSystem> = [SI, USA, UK, Canada]

export const unitsystemFromSymbol = (s: string): Option<UnitSystem> =>
  first(_.filter((lang: UnitSystem): boolean => lang.sym === s)(UnitSystems))
