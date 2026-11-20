// Proof bodies: plain strings, and the end-of-proof square.
#import "@preview/unofficial-monash-report:0.2.0": *
#let mode = sys.inputs.at("mode", default: "assignment")
#show: if mode == "report" { report.with(title: [Proofs]) } else {
  assignment.with(title: [Proofs])
}
#theorem[A string proof follows.]
#proof("This proof is a plain string.")
