// Unnumbered chapters neither reset nor prefix numbers; content before
// chapter 1 has no chapter prefix.
#import "@preview/unofficial-monash-report:0.2.0": *
#import "../src/figures.typ": number-at
#show: report.with(title: [Unnumbered chapters], outline: true)
#let sample(caption) = figure(rect(width: 2cm, height: 1cm), caption: caption)
$ a = b $ <eq-pre>
#sample[Before any chapter.] <fig-pre>
#heading(numbering: none)[Acknowledgements]
#sample[In an unnumbered chapter.] <fig-ack>
#theorem[Before chapter one.] <thm-pre>
= One
#sample[In chapter one.] <fig-one>
#theorem[In chapter one.] <thm-one>
#heading(numbering: none)[Interlude]
#sample[In an unnumbered chapter after chapter one.] <fig-interlude>
#appendix[
  = Extra
  #sample[In appendix A.] <fig-a>
  #heading(numbering: none)[Unnumbered appendix chapter]
  $ p = q $ <eq-unnumbered>
  #sample[In an unnumbered appendix chapter.] <fig-unnumbered>
  = Second
  #sample[In appendix B.] <fig-b>
]
#context {
  let o = (mode: "report")
  for (target, expected) in (
    (<eq-pre>, "(1)"), (<fig-pre>, "1"), (<fig-ack>, "2"), (<thm-pre>, "1"),
    (<fig-one>, "1.1"), (<thm-one>, "1.1"), (<fig-interlude>, "1.2"),
    (<fig-a>, "A.1"), (<eq-unnumbered>, "(A.1)"), (<fig-unnumbered>, "A.2"),
    (<fig-b>, "B.1"),
  ) {
    assert.eq(number-at(o, query(target).first()), expected, message: repr(target))
  }
}
See @fig-pre, @fig-ack, @fig-interlude, @fig-unnumbered and @eq-unnumbered.
