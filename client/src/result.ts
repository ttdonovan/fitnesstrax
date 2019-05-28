class Result<A, E> {
  ok_: A | null
  err_: E | null

  constructor(ok: A | null, err: E | null) {
    if (ok && !err) {
      this.ok_ = ok
      this.err_ = null
    } else if (!ok && err) {
      this.ok_ = null
      this.err_ = err
    } else {
      throw new Error("cannot create a Result with both ok and err values")
    }
  }

  static Ok<A>(val: A): Result<A, any> {
    return new Result(val, null)
  }

  static Err<E>(err: E): Result<any, E> {
    return new Result(null, err)
  }

  map<B>(f: (_: A) => B): Result<B, E> {
    if (this.ok_) {
      return Result.Ok(f(this.ok_))
    }
    if (this.err_) {
      return Result.Err(this.err_)
    }

    throw new Error("Invalid Result state")
  }

  map_err<F>(f: (_: E) => F): Result<A, F> {
    if (this.err_) {
      return Result.Err(f(this.err_))
    }
    if (this.ok_) {
      return Result.Ok(this.ok_)
    }
    throw new Error("Invalid Result state")
  }

  unwrap(): A {
    if (this.ok_) {
      return this.ok_
    }
    throw new Error("forced unwrap of an empty Result")
  }
}

export default Result
