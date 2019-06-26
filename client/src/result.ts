type ResultOk<A> = { type_: "OK"; ok: A }
type ResultErr<E> = { type_: "ERR"; err: E }
type ResultRepr<A, E> = ResultOk<A> | ResultErr<E>

const resultReprIsOk = <A, E>(res: ResultRepr<A, E>): res is ResultOk<A> =>
  (<ResultOk<A>>res).type_ === "OK"
const resultReprIsErr = <A, E>(res: ResultRepr<A, E>): res is ResultErr<E> =>
  (<ResultErr<E>>res).type_ === "ERR"

class Result<A, E> {
  val: ResultRepr<A, E>

  constructor(which: "ok" | "err", ok: A | null, err: E | null) {
    if (which === "ok") {
      this.val = { type_: "OK", ok: <A>ok }
    } else {
      this.val = { type_: "ERR", err: <E>err }
    }
  }

  static Ok<A>(val: A): Result<A, any> {
    return new Result("ok", val, null)
  }

  static Err<E>(err: E): Result<any, E> {
    return new Result("err", null, err)
  }

  static try<A, E>(f: () => A): Result<A, E> {
    try {
      return Result.Ok(f())
    } catch (e) {
      return Result.Err(e)
    }
  }

  isOk(): boolean {
    return resultReprIsOk(this.val)
  }

  isErr(): boolean {
    return resultReprIsErr(this.val)
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

  mapErr<F>(f: (_: E) => F): Result<A, F> {
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
    throw new Error("forced unwrap of an errored Result")
  }

  unwrapErr(): E {
    if (resultReprIsErr(this.val)) {
      return this.val.err
    }
    throw new Error("forced error unwrap of an ok Result")
  }
}

export const sequenceResult = <A, E>(
  lst: Array<Result<A, E>>,
): Result<Array<A>, E> => {
  let res = []
  for (var v of lst) {
    if (v.isOk()) {
      res.push(v.unwrap())
    } else {
      return Result.Err(v.unwrapErr())
    }
  }
  return Result.Ok(res)
}

export default Result
