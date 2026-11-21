// Proof bodies: plain strings, and the end-of-proof square, which sits on the last
// line of a closing list item rather than on a line of its own.
#import "@preview/unofficial-monash-report:0.2.0": *
#let mode = sys.inputs.at("mode", default: "assignment")
#show: if mode == "report" { report.with(title: [Proofs]) } else {
  assignment.with(title: [Proofs])
}
#theorem[A string proof follows.]
#proof("This proof is a plain string.")
#theorem[A list proof follows.]
#proof[
  We check:
  - first case;
  - second case.
]
#theorem[An equation proof follows.]
#proof[
  We check:
  $ a &= b \ &= c $
]
#proof[Inline text ends the proof.]
#let list-body = [
  We check:
  - first case;
  - second case.
]
#let enum-body = [
  We check:
  + first case;
  + second case, which is long enough to need a second line of text in the proof here.
]
#context {
  // Same height as the body alone: the square adds no line.
  for body in (list-body, enum-body, [Inline text.]) {
    let width = 300pt
    let with-square = measure(block(width: width, proof(body))).height
    let plain-body = measure(block(width: width, block(breakable: true)[_Proof._ #body])).height
    assert(
      calc.abs((with-square - plain-body).pt()) < .01,
      message: "the square took a line of its own: " + repr((with-square, plain-body)),
    )
  }
}
#proof(enum-body)
