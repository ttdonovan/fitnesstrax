import { Option } from "ld-ambiguity"
import _ from "lodash/fp"
import { Duration } from "luxon"
import math from "mathjs"
import moment from "moment-timezone"

import Equals from "./equals"
//import "./moment-extensions"
import { Record } from "./types"
import trace from "./trace"

/* pulled this directly from https://stackoverflow.com/questions/35325370/how-to-post-a-x-www-form-urlencoded-request-from-react-native */
export const encodeFormBody = (params: { [_: string]: string }): string =>
  _.keys(params)
    .map(key => encodeURIComponent(key) + "=" + encodeURIComponent(params[key]))
    .join("&")

/* And then these functions come from Javascript Allonge */

/* return true if the value isSomething */
export const isSomething = (value: any | null | undefined): boolean =>
  value != null && value != void 0

/* maybe(someFunction)(possibly null value)
 * execute someFunction if the values are present and all are defined.
 * This is not exactly like `maybe :: b -> (a -> b) -> Maybe a -> b`, but
 * instead akin to `fmap :: (a -> b) -> f a -> f b`, but less general.
 */
/*
export const maybe = fn =>
  function(...args) {
    if (args.length === 0) {
      return
    } else {
      for (let arg of args) {
        if (arg == null) return
      }
      return fn.apply(this, args)
    }
  }
     */

/* intercalate `val` in between every element of `lst` */
/*
export const intercalate = (lst, val) => {
  if (lst.length <= 1) {
    return lst
  }

  let [r, ...rest] = lst
  return r + val + intercalate(rest, val)
}
     */

//export const sum = s => s.reduce((a, b) => a + b, 0)
//export const divmod = (n, d) => [math.floor(n / d), n % d]
//export const padStr = (str, chr, size) => chr.repeat(size - str.length) + str

/* Given a list of values, return the first not-null value. Return null only if all values are null. */
export const first = <A>(lst: Array<A>): Option<A> => {
  if (!isSomething(lst)) {
    return Option.None()
  }
  if (lst.length == 0) {
    return Option.None()
  }
  const [fst, ...rest] = lst
  return isSomething(fst) ? Option.Some(fst) : first(rest)
}

/*
export const firstFn = fn => lst => {
  if (!isSomething(lst)) {
    return null
  }
  if (lst.length == 0) {
    return null
  }
  const [fst, ...rest] = lst
  var res = fn(fst)
  return res ? fst : firstFn(fn)(rest)
}
     */

// This keyBy function is much like _.keyBy, except that it returns all of the
// values that match a key, not just the last one.
export const keyBy = <K, V>(
  f: (_: V) => K,
): ((_: Array<V>) => Map<K, Array<V>>) => lst => {
  const m: Map<K, Array<V>> = new Map()
  lst.forEach(elem => {
    const key = f(elem)
    const curLst: Array<V> | null | undefined = m.get(key)
    if (!isSomething(curLst)) {
      m.set(key, [elem])
    } else {
      m.set(key, [...(<Array<V>>curLst), elem])
    }
  })
  return m
}

/*
export const listToMap = (f, lst) =>
  lst.map(v => [f(v), v]).reduce((m, [k, v]) => {
    m[k] = v
    return m
  }, {})
   */

/*
export const mapFromTuples = <A>(lst: Array<[string, A]>): object => {
  var m = {}
  for (var i in lst) {
    const [key, value] = lst[i]
    if (isSomething(m[key])) {
      m[key] = [].concat(m[key], value)
    } else {
      m[key] = [value]
    }
  }
  return m
}
     */

const parseRfc3339 = (str: string): Option<moment.Moment> => {
  const m = moment(str)
  return m.isValid() ? Option.Some(m) : Option.None()
}

export const parseDTZ = (str: string): Option<moment.Moment> => {
  const parts = str.split(" @ ")
  if (parts.length === 2) {
    const dtz = moment(parts[0]).tz(parts[1])
    return dtz.isValid() ? Option.Some(dtz) : Option.None()
  } else {
    const dtz = moment(parts[0])
    return dtz.isValid() ? Option.Some(dtz) : Option.None()
  }
}

/*
export const renderDate = (d: moment.Moment): string => d.format("YYYY-MM-DD")
export const parseDate = str =>
  parseDate_(str, "YYYY-MM-DD") || parseDate_(str, "MM-DD-YYYY")

export const renderTime = d => d.format("YYYY-MM-DD HH:mm")
export const parseTime = str => parseDate_(str, "YYYY-MM-DD HH:mm")

export const parseDate_ = (str, fmt) => {
  var m = moment(str, fmt, true)
  return m.isValid() ? m : null
}
   */

/*
export const renderWeight = w => w.to("kg").format(3)
export const parseWeight = str => parseUnit(str)

export const renderDistance = d => d.to("km").format()
   */

export const parseDuration = (str: string): Option<Duration> => {
  /* TODO: put in a bunch of code to reject invalid strings */
  const lst = str.split(":")
  var m = null
  if (lst.length == 1) {
    m = Duration.fromObject({ seconds: parseInt(lst[0]) })
  } else if (lst.length == 2) {
    m = Duration.fromObject({
      minutes: parseInt(lst[0]),
      seconds: parseInt(lst[1]),
    })
  } else if (lst.length == 3) {
    m = Duration.fromObject({
      hours: parseInt(lst[0]),
      minutes: parseInt(lst[1]),
      seconds: parseInt(lst[2]),
    })
  }
  return new Option(m)
}

/* TODO: maybe parseDuration should return an object that has had equals hacked in, and I should also provide a general constructor that does it. */
/*
export const equalDurations = (
  left: moment.Duration,
  right: moment.Duration,
): boolean =>
  left.milliseconds() == right.milliseconds() &&
  left.days() == right.days() &&
  left.months() == right.months()
   */

export const parseUnit = (str: string): Option<math.Unit> => {
  try {
    return Option.Some(math.unit(str))
  } catch (e) {
    if (e instanceof SyntaxError) {
      return Option.None()
    } else {
      throw e
    }
  }
}

/*
export const toUTC = t => t.clone().utc()
export const toTz = (t, offset) => t.clone().utcOffset(offset)
export const midnight = t => t.clone().set({ hour: 0, minute: 0, second: 0 })
   */
