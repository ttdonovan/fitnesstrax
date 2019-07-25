import { IANAZone } from "luxon"
import { Date, DateTimeTz } from "../datetimetz"

const UTC = IANAZone.create("UTC")

export class Range<A> {
  constructor(readonly start: A, readonly end: A) {}

  setStart(val: A): Range<A> {
    return new Range(val, this.end)
  }
  setEnd(val: A): Range<A> {
    return new Range(this.start, val)
  }

  map<B>(f: (_: A) => B): Range<B> {
    return new Range(f(this.start), f(this.end))
  }
}

export const daysInRange = (range: Range<DateTimeTz>): Array<Date> => {
  let current = range.start
  let lst = []
  while (current.timestamp < range.end.timestamp) {
    lst.push(current.toDate())
    current = current.map(c => c.plus({ days: 1 }))
  }
  lst.push(current.toDate())
  return lst
}
