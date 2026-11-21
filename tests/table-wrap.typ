// Long cell text wraps (ragged) at the column width instead of shrinking the table.
#import "@preview/unofficial-monash-report:0.2.0": *
#import "../src/design.typ": test-wide-width, zero
#let mode = sys.inputs.at("mode", default: "assignment")
#show: if mode == "report" { report.with(title: [Tables]) } else {
  assignment.with(title: [Tables])
}
#let mark(name) = [#box(width: zero)#label(name)]
#table(
  columns: 2, table.header[Name][Description],
  [#mark("wrap-top")alpha], [#lorem(60)],
  [#mark("wrap-bottom")beta], [short#mark("wrap-right")],
  // Wrapped cells are set ragged, not justified.
  [#context assert.eq(par.justify, false)], [],
)
#figure(
  table(
    columns: 2, table.header[Name][Description],
    [#mark("figure-top")alpha], [#lorem(60)], [#mark("figure-bottom")beta], [short],
  ),
  caption: [Wrapping text in a figure.],
)
// Fixed widths wider than the text column still shrink to fit.
#table(
  columns: (test-wide-width / 2, test-wide-width / 2),
  [#mark("wide-left")Left], [Right#mark("wide-right")],
)
#context {
  let at(name) = locate(label(name)).position()
  // A row of 60 words wraps to several lines at body text size.
  for prefix in ("wrap", "figure") {
    let height = at(prefix + "-bottom").y - at(prefix + "-top").y
    assert(height > 40pt, message: prefix + " table was shrunk: " + repr(height))
  }
  let right-edge = page.width - page.margin.right
  assert(at("wrap-right").x < right-edge, message: "wrapped table overflows")
  assert(at("wide-right").x < right-edge, message: "wide table overflows")
}
