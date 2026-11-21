// `font-size` scales every body-level size, not only paragraph text. At 22pt
// everything is twice its 11pt size.
#import "@preview/unofficial-monash-report:0.2.0": *
#show: assignment.with(title: [Font size], font-size: 22pt)
#let size-is(expected) = context assert.eq(text.size, expected)
#size-is(22pt)
= Chapter #size-is(42pt)
== Section #size-is(26pt)
=== Subsection #size-is(22pt)
#question(title: [Title #size-is(26pt)], marks: [#size-is(21pt)3 marks])[Statement.]
#figure(rect(width: 1cm, height: 1cm), caption: [Caption #size-is(20pt)])
#table(columns: 1, [Cell #size-is(21pt)])
Text with a note.#footnote[Note #size-is(19pt)]
$ x = #size-is(24pt) $
#theorem[Statement #size-is(22pt)]
