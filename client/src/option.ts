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

  is_some(): boolean {
    return Boolean(this.val_)
  }

  is_none(): boolean {
    return !Boolean(this.val_)
  }

  map<B>(f: (_: A) => B): Option<B> {
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
}

export default Option
