import math from 'mathjs'
import moment from 'moment'

/* pulled this directly from https://stackoverflow.com/questions/35325370/how-to-post-a-x-www-form-urlencoded-request-from-react-native */
export const encodeFormBody = params => 
    Object.keys(params).map(key => encodeURIComponent(key)
                                 + '='
                                 + encodeURIComponent(params[key])).join('&')


/* And then these functions come from Javascript Allonge */

/* return true if the value isSomething */
export const isSomething = (value) => value != null && value != void 0;

/* maybe(someFunction)(possibly null value)
 * execute someFunction if the values are present and all are defined.
 * This is not exactly like `maybe :: b -> (a -> b) -> Maybe a -> b`, but
 * instead akin to `fmap :: (a -> b) -> f a -> f b`, but less general.
 */
export const maybe = (fn) =>
    function (...args) {
        if (args.length === 0) {
            return
        } else {
            for (let arg of args) {
                if (arg == null) return;
            }
            return fn.apply(this, args)
        }
    }

/* intercalate `val` in between every element of `lst` */
export const intercalate = (lst, val) => {
    if (lst.length <= 1) { return lst }

    let [r, ...rest] = lst;
    return r + val + intercalate(rest, val);
}

export const sum = s => s.reduce((a, b) => a + b, 0)
export const divmod = (n, d) => [math.floor(n / d), n % d]
export const padStr = (str, chr, size) => chr.repeat(size - str.length) + str

/* Given a list of values, return the first not-null value. Return null only if all values are null. */
export const first = (lst) => {
    if (!isSomething(lst)) {
        return null
    }
    if (lst.length == 0) {
        return null
    }
    const [fst, ...rest] = lst
    return isSomething(fst) ? fst : first(rest)
}

export const firstFn = (fn) => (lst) => {
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

export const nub = (lst) => Array.from(new Set(lst))

export const indexList = (f, lst) => mapFromTuples(lst.map((v) => [f(v), v]))
export const listToMap = (f, lst) => lst.map((v) => [f(v), v]).reduce((m, [k, v]) => { m[k] = v; return m }, {})

export const mapFromTuples = (lst) => {
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

export const renderDate = (d) => d.format('YYYY-MM-DD')
export const parseDate = (str) => parseDate_(str, 'YYYY-MM-DD') || parseDate_(str, 'MM-DD-YYYY')

export const renderTime = (d) => d.format('YYYY-MM-DD HH:mm')
export const parseTime = (str) => parseDate_(str, 'YYYY-MM-DD HH:mm')

export const parseDate_ = (str, fmt) => {
    var m = moment(str, fmt, true)
    return m.isValid() ? m : null
}

export const renderWeight = (w) => w.to('kg').format(3)
export const parseWeight = (str) => parseUnit(str)

export const renderDistance = (d) => d.to('km').format()

export const renderDuration = (t) => t.format('HH:mm:ss')
export const parseDuration = (str) => {
    const lst = str.split(':')
    var m = null;
    if (lst.length == 1) {
        m = moment.duration({seconds: lst[0]})
    } else if (lst.length == 2) {
        m = moment.duration({ minutes: lst[0]
                            , seconds: lst[1]
                            })
    } else if (lst.length == 3) {
        m = moment.duration({ hours: lst[0]
                            , minutes: lst[1]
                            , seconds: lst[2]
                            })
    }
    return isSomething(m) && m.isValid() ? m : null
}

/* TODO: maybe parseDuration should return an object that has had equals hacked in, and I should also provide a general constructor that does it. */
export const equalDurations = (left, right) =>
        left._milliseconds == right._milliseconds
    &&  left._days == right._days
    &&  left._months == right._months

export const parseUnit = (str) => {
    try {
        return math.unit(str)
    } catch (e) {
        if (e instanceof SyntaxError) {
            return null
        } else {
            throw e
        }
    }
}

export const toUTC = (t) => t.clone().utc()
export const toTz = (t, offset) => t.clone().utcOffset(offset)
export const midnight = (t) => t.clone().set({hour: 0, minute: 0, second: 0})
