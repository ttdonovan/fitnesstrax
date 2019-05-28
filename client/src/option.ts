import Equals from "./equals"

class Option<A extends Equals> {
  val_: A | null

  constructor(val: A | null) {
    this.val_ = val
  }

  static Some<A extends Equals>(val: A): Option<A> {
    return new Option(val)
  }

  static None<A extends Equals>(): Option<A> {
    return new Option<A>(null)
  }

  is_some(): boolean {
    return Boolean(this.val_)
  }

  is_none(): boolean {
    return !Boolean(this.val_)
  }

  map<B extends Equals>(f: (_: A) => B): Option<B> {
    if (this.val_) {
      return Option.Some(f(this.val_))
    }
    return Option.None()
  }

  unwrap(): A {
    if (this.val_) {
      return this.val_
    }
    throw new Error("forced unwrap of an empty Option")
  }

  equals<A extends Equals>(rside: Option<A>): boolean {
    if (this.val_ && rside.val_) {
      return this.val_.equals(rside.val_)
    } else if (this.is_none() && rside.is_none()) {
      return true
    } else {
      return false
    }
  }
}

export default Option
