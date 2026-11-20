// Lists of figures and tables number each entry at its element.
#import "@preview/unofficial-monash-report:0.2.0": *
#import "../src/figures.typ": entry-prefix
#import "../src/options.typ": plain
#show: report.with(title: [Lists of figures], outline: true)
#outline(title: [List of Figures], target: figure.where(kind: image))
#outline(title: [List of Tables], target: figure.where(kind: table))
#let sample(caption) = figure(rect(width: 2cm, height: 1cm), caption: caption)
#sample[Before chapter one.] <fig-pre>
= One
#sample[First.] <fig-one>
#figure(table(columns: 1, [Cell]), caption: [A table.]) <tab-one>
= Two
#sample[Second.] <fig-two>
#sample[Third.] <fig-three>
#context {
  let o = (mode: "report")
  for (target, expected) in (
    (<fig-pre>, "Figure 1"), (<fig-one>, "Figure 1.1"), (<tab-one>, "Table 1.1"),
    (<fig-two>, "Figure 2.1"), (<fig-three>, "Figure 2.2"),
  ) {
    assert.eq(plain(entry-prefix(o, query(target).first())), expected)
  }
}
