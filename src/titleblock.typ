#import "design.typ": *
#import "options.typ": present, date-text
#let titleblock(o) = {
  set par(justify: false, leading: title-leading)
  if present(o.logo) or present(o.unit) or present(o.semester) {
    block(width: full, below: title-gap)[
      #grid(columns: (1fr, 1fr), align: bottom,
        if present(o.logo) { scale(y: assignment-logo-height / measure(o.logo).height, reflow: true, o.logo) },
        align(right, text(font: o.heading-font, size: furniture-size, fill: monash-grey-dark,
          (o.unit, o.semester).filter(present).join(linebreak()))))
    ]
  }
  block(below: byline-gap, text(font: o.heading-font, size: assignment-title-size, weight: light-weight, fill: o.accent, o.title))
  let items = ()
  if present(o.author) { items.push(text(weight: "bold", fill: monash-black, o.author)) }
  if present(o.student-id) { items.push(o.student-id) }
  if present(o.tutor) { items.push([Tutor: #o.tutor]) }
  if present(o.date) { items.push(date-text(o.date)) }
  items += o.info.filter(present)
  if items.len() > 0 {
    block(text(font: o.heading-font, size: byline-size, fill: monash-grey-dark, items.join([ · ])))
  }
  v(rule-gap)
  notch-rule()
  v(first-question-gap - notch-depth)
}
