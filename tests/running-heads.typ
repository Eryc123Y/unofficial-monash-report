// Running heads and footers stay on one line.
#import "@preview/unofficial-monash-report:0.2.0": *
#import "../src/page.typ": furniture, current-chapter
#let mode = sys.inputs.at("mode", default: "assignment")
#let long-title = [
  An Empirical Study of Heuristic Search Algorithms \ for Large-Scale Multi-Robot Warehouse
  Routing Under Uncertainty
]
#let opts = (
  title: long-title, author: "A Very Long Author Name That Keeps Going", student-id: "12345678",
  unit: "FIT3162 Computer Science Project",
)
#show: if mode == "report" { report.with(..opts, outline: true) } else {
  assignment.with(..opts)
}
#outline(title: [List of Figures], target: figure.where(kind: image))
#metadata(none) <before-chapters>
Text before the first chapter.
#context {
  let o = (heading-font: text.font)
  let width = 400pt
  let one = measure(block(width: width, furniture(o, [Left], [Right]))).height
  for (left, right) in (
    (long-title, long-title), (lorem(30), [1]), ([Short], lorem(30)), (lorem(30), lorem(30)),
  ) {
    let height = measure(block(width: width, furniture(o, left, right))).height
    assert.eq(height, one, message: "furniture wrapped onto a second line")
  }
}
#pagebreak()
= A Very Long Chapter Heading That Runs Well Past Seventy Characters To Test Wrapping in Heads
#metadata(none) <in-chapter>
#context if mode == "report" {
  assert.eq(current-chapter(locate(<in-chapter>)).body, query(heading.where(level: 1)).last().body)
}
#lorem(400)
