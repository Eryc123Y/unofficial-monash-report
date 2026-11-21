// The unit line in the assignment title block wraps between words, never inside one.
#import "@preview/unofficial-monash-report:0.2.0": *
#let mark(name) = [#box(width: 0pt)#label(name)]
#let words = (
  "FIT3080", "Artificial", "Intelligence", "and", "Intelligent", "Systems", "Extended",
  "Internationalisation", "Considerations",
)
#show: assignment.with(
  title: [Unit line],
  unit: words.enumerate().map(((i, word)) => {
    [#word#mark("end-" + str(i))]
  }).join([ ]),
  semester: "Semester 2, 2026",
)
#context {
  // The unit line is right-aligned, so the last whole word on every line ends at the
  // right margin. A hyphenated fragment after it would push it left.
  let end(i) = locate(label("end-" + str(i))).position()
  let right-edge = page.width - page.margin.right.length
  let last = words.len() - 1
  assert(end(last).y > end(0).y, message: "the unit line did not wrap")
  for i in range(words.len()) {
    if i == last or end(i + 1).y > end(i).y {
      let gap = calc.abs((end(i).x - right-edge).pt())
      assert(gap < .01, message: "hyphenated after " + words.at(i))
    }
  }
}
