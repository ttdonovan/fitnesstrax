const trace = <A>(msg: string): ((_: A) => A) => val => {
  console.log(`[${msg}] ${val}`)
  return val
}

export default trace
