#import "design.typ": *
#import "question.typ": show-question
#import "theorems.typ": show-statement, chapter-number
#let numberer(o, n) = context {
  if o.mode == "report" { chapter-number() + "." + str(n) } else { str(n) }
}
#let figure-style(o, body) = {
  set figure(numbering: n => numberer(o, n), gap: caption-gap)
  set figure.caption(separator: [. ])
  set math.equation(numbering: n => [(#numberer(o, n))], number-align: right)
  set table(stroke: (x, y) => (bottom: if y == 0 { hairline + monash-black }), inset: table-inset,
    align: (x, y) => if x == 0 { left } else { right })
  show table: it => {
    if it.has("label") and it.label == <monash-three-line-table> { it } else {
      let fields = it.fields()
      let children = fields.remove("children")
      fields.remove("label", default: none)
      align(center, [#table(..fields,
        table.hline(stroke: table-rule + monash-black),
        ..children,
        table.hline(stroke: table-rule + monash-black))<monash-three-line-table>])
    }
  }
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: raw): set figure(supplement: [Listing])
  show figure.caption: it => context {
    set align(center)
    set text(size: caption-size)
    // The caption supplies its supplement and counter directly.
    text(font: o.heading-font, size: caption-size, weight: "bold", fill: o.accent)[
      #it.supplement #it.counter.display(it.numbering).
    ]
    [ #it.body]
  }
  show figure.where(kind: "question"): show-question
  show figure.where(kind: "theorem"): show-statement
  if o.mode == "report" {
    show heading.where(level: 1): it => {
      for kind in (image, table, raw, "theorem") { counter(figure.where(kind: kind)).update(0) }
      counter(math.equation).update(0)
      it
    }
  }
  body
}
