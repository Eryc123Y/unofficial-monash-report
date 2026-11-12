#import "@preview/unofficial-monash-report:0.1.0": *
#import "../src/figures.typ": number-at
#let mode = sys.inputs.at("mode", default: "assignment")
#let opts = (title: [Numbering], date: none)
#show: if mode == "report" {
  report.with(..opts, abstract: [Front matter.], outline: true)
} else { assignment.with(..opts) }
= First chapter
$ x=1 $ <eq-one>
#figure([First image], caption: [First.]) <fig-one>
#figure(table(columns: 1, [Cell]), caption: [First table.]) <tab-one>
#figure(raw("let x = 1", block: true), caption: [First listing.]) <code-one>
#theorem[First.] <thm-one>
#lemma[Second.] <thm-two>
#metadata("body-start") <body-start>
#pagebreak()
= Second chapter
$ x=2 $ <eq-two>
#figure([Second image], caption: [Second.]) <fig-two>
#figure(table(columns: 1, [Cell]), caption: [Second table.]) <tab-two>
#figure(raw("let x = 2", block: true), caption: [Second listing.]) <code-two>
#definition[Third statement.] <thm-three>
#context {
  let expected = if mode == "report" { ("1.1", "2.1") } else { ("1", "2") }
  for (labels, expected-values) in (
    ((<eq-one>, <eq-two>), expected),
    ((<fig-one>, <fig-two>), expected),
    ((<tab-one>, <tab-two>), expected),
    ((<code-one>, <code-two>), expected),
    ((<thm-one>, <thm-three>), if mode == "report" { expected } else { ("1", "3") }),
  ) {
    for (target, number) in labels.zip(expected-values) {
      let el = query(target).first()
      let c = if el.func() == math.equation {
        counter(math.equation)
      } else { counter(figure.where(kind: el.kind)) }
      let actual = number-at((mode: mode), el)
      assert.eq(actual, if el.func() == math.equation { "(" + number + ")" } else { number })
      assert.eq(c.at(el.location()).first(), int(number.split(".").last()), message: repr(target))
      if mode == "report" {
        assert.eq(counter(heading).at(el.location()).first(), int(number.split(".").first()))
      }
    }
  }
  assert.eq(counter(figure.where(kind: "theorem")).at(<thm-two>).first(), 2)
  assert.eq(counter(page).at(<body-start>).first(), 1)
  assert.eq(query(<body-start>).first().location().page-numbering(), "1")
  if mode == "report" {
    let contents = query(outline).first()
    assert.eq(counter(page).at(contents.location()).first(), 1)
    assert.eq(contents.location().page-numbering(), "i")
    assert.eq(contents.location().page() + 1, query(<body-start>).first().location().page())
  }
}
#if mode == "report" {
  appendix[
    = Supplement
    $ x=3 $ <eq-appendix>
    #lemma[Appendix.] <thm-appendix>
    #context {
      assert.eq(counter(heading).get().first(), 1)
      assert.eq(counter(math.equation).at(<eq-appendix>).first(), 1)
      assert.eq(counter(figure.where(kind: "theorem")).at(<thm-appendix>).first(), 1)
      assert.eq(query(<eq-appendix>).first().location().page-numbering(), "1")
    }
    See @eq-appendix and @thm-appendix.
  ]
}
See @eq-one, @eq-two, @fig-one, @fig-two, @thm-one, @thm-two and @thm-three.
