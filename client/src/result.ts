type ResultOk<A> = { type_: "OK"; ok: A | null }
type ResultErr<E> = { type_: "ERR"; err: E | null }
type ResultRepr<A, E> = ResultOk<A> | ResultErr<E>

const resultReprIsOk = <A, E>(res: ResultRepr<A, E>): res is ResultOk<A> =>
  (<ResultOk<A>>res).type_ === "OK"
const resultReprIsErr = <A, E>(res: ResultRepr<A, E>): res is ResultErr<E> =>
  (<ResultErr<E>>res).type_ === "ERR"

class Result<A, E> {
  val: ResultRepr<A, E>

  constructor(which: "ok" | "err", ok: A | null, err: E | null) {
    if (which === "ok") {
      this.val = { type_: "OK", ok }
    } else {
      this.val = { type_: "ERR", err }
    }
  }

  static Ok<A>(val: A): Result<A, any> {
    return new Result("ok", val, null)
  }

  static Err<E>(err: E): Result<any, E> {
    return new Result("err", null, err)
  }

  map<B>(f: (_: A) => B): Result<B, E> {
    if (resultReprIsOk(this.val)) {
      return Result.Ok(f(this.val.ok))
    }
    if (resultReprIsErr(this.val)) {
      return Result.Err(this.val.err)
    }

    throw new Error("Invalid Result state")
  }

  map_err<F>(f: (_: E) => F): Result<A, F> {
    if (resultReprIsErr(this.val)) {
      return Result.Err(f(this.val.err))
    }
    if (resultReprIsOk(this.val)) {
      return Result.Ok(this.val.ok)
    }
    throw new Error("Invalid Result state")
  }

  unwrap(): A {
    if (resultReprIsOk(this.val)) {
      return this.val.ok
    }
    throw new Error("forced unwrap of an empty Result")
  }
}

export default Result
