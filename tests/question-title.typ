// A long question title wraps before the marks, leaving a gap.
#import "@preview/unofficial-monash-report:0.2.0": *
#let mode = sys.inputs.at("mode", default: "assignment")
#show: if mode == "report" { report.with(title: [Questions]) } else {
  assignment.with(title: [Questions])
}
#let mark(name) = [#box(width: 0pt)#label(name)]
#let words = "A very long question title that goes on and on until it must wrap onto another line"
#let title = words.split(" ").enumerate().map(((i, word)) => [#word#mark("word-" + str(i))])
#question(marks: [#mark("marks")15 marks], title: title.join([ ]))[Statement.]
#context {
  let marks = locate(<marks>).position()
  for i in range(words.split(" ").len()) {
    let end = locate(label("word-" + str(i))).position()
    assert(end.x <= marks.x - 6pt, message: "title runs into the marks: word " + str(i))
  }
  // The title wraps, and the marks sit on its first line.
  let last = locate(label("word-" + str(words.split(" ").len() - 1))).position()
  assert(last.y > locate(<word-0>).position().y, message: "title did not wrap")
}
