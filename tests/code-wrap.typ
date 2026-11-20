// A long code line wraps inside the listing and pushes later content down.
#import "@preview/unofficial-monash-report:0.2.0": *
#let mode = sys.inputs.at("mode", default: "assignment")
#show: if mode == "report" { report.with(title: [Code]) } else {
  assignment.with(title: [Code])
}
#let long-line = "return x  # " + "a very long comment that keeps going " * 6
#let short = raw("def f(x):\n    return x", block: true, lang: "python")
#let long = raw("def f(x):\n    " + long-line, block: true, lang: "python")
#short
#long
#figure(long, caption: [A wrapped line in a listing.])
#context {
  let width = 300pt
  // Lines sit 14.4pt apart at the 9pt code size, inside 7.5pt top and bottom insets.
  let line = 14.4pt
  let short-height = measure(short, width: width).height
  let long-height = measure(long, width: width).height
  assert(
    calc.abs((short-height - (2 * line + 15pt)).pt()) < .01,
    message: "listing line height changed: " + repr(short-height),
  )
  // The long line wraps to at least three lines at this width, each a full line high.
  assert(
    long-height >= short-height + 2 * line - .01pt,
    message: "listing height ignores wrapped lines: " + repr((short-height, long-height)),
  )
}
