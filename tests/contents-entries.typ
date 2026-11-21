// Contents entries: unnumbered entries start at the margin, wrapped entries hang
// after their number, and no entry is hyphenated.
#import "@preview/unofficial-monash-report:0.2.0": *
#let mark(name) = [#box(width: 0pt)#label(name)]
#show: report.with(title: [Contents entries], outline: true)
#let long = (
  "A chapter title that is long enough to wrap onto a second line of the contents page"
    + " and then some more words to be sure"
)
#let words = long.split(" ")
#heading(numbering: none)[#mark("ack-start")Acknowledgements]
= #mark("one-start")One
= #words.enumerate().map(((i, word)) => [#word#mark("word-" + str(i))]).join([ ])
#context {
  // Marks in a heading body appear twice: first in the contents, then in the body.
  let at(name) = query(label(name)).first().location().position()
  let margin = page.margin.left.length
  assert(calc.abs((at("ack-start").x - margin).pt()) < .01, message: "unnumbered entry indented")
  assert(at("one-start").x > margin, message: "numbered entry has no number")
  let body-start = at("word-0").x - measure(strong(words.first())).width
  let wrapped = false
  for i in range(1, words.len()) {
    if at("word-" + str(i)).y > at("word-" + str(i - 1)).y {
      wrapped = true
      // The first word of the new line starts where the first line's text started.
      let start = at("word-" + str(i)).x - measure(strong(words.at(i))).width
      assert(
        calc.abs((start - body-start).pt()) < .01,
        message: "no hanging indent: " + repr((start, body-start)),
      )
    }
  }
  assert(wrapped, message: "the long entry did not wrap")
}
