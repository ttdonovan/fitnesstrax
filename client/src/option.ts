import Equals from "./equals"

class Option<A> {
  val_: A | null

  constructor(val: A | null) {
    this.val_ = val
  }

  static Some<A>(val: A): Option<A> {
    return new Option(val)
  }

  static None<A>(): Option<A> {
    return new Option<A>(null)
  }

  isSome(): boolean {
    return Boolean(this.val_)
  }

  isNone(): boolean {
    return !Boolean(this.val_)
  }

  map<B>(f: (_: A) => B): Option<B> {
    if (this.val_) {
      return Option.Some(f(this.val_))
    }
    return Option.None()
  }

  andThen<B>(f: (_: A) => Option<B>): Option<B> {
    if (this.val_) {
      return f(this.val_)
    }
    return Option.None()
  }

  or(def: A): A {
    if (this.val_) {
      return this.val_
    }
    return def
  }

  unwrap(): A {
    if (this.val_) {
      return this.val_
    }
    throw new Error("forced unwrap of an empty Option")
  }

  equals(rside: Option<A>): boolean {
    if (this.val_ && rside.val_) {
      if ((<Equals>(<unknown>this.val_)).equals) {
        return (<Equals>(<unknown>this.val_)).equals(<Equals>(
          (<unknown>rside.val_)
        ))
      } else {
        return this.val_ === rside.val_
      }
    } else if (this.isNone() && rside.isNone()) {
      return true
    } else {
      return false
    }
  }
}

export default Option
