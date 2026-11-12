#import "design.typ": *
#import "options.typ": require, valid-text, present
#import "page.typ": current-config
#let question(marks: none, title: none, number: auto, ..args) = {
  for key in args.named().keys() { panic("unknown argument `" + key + "`") }
  require("body", args.pos().len() <= 1, "at most one statement")
  let body = args.pos().at(0, default: none)
  require("marks", marks == none or type(marks) in (int, float, str, content), "none, number, str, or content")
  require("title", valid-text(title), "none, str, or content")
  require("number", number == auto or type(number) == int and number > 0, "auto or a positive integer")
  require("body", valid-text(body), "none, str, or content")
  if number != auto { counter(figure.where(kind: "question")).update(number - 1) }
  figure(metadata((title: title, marks: marks, statement: body)), kind: "question", supplement: [Question], numbering: "1")
}
#let show-question(it) = context {
  let o = current-config()
  set align(left)
  let data = it.body.value
  block(above: question-above, below: question-gap, sticky: true,
    grid(columns: (1fr, auto),
      text(font: o.heading-font, size: section-size, weight: "bold", fill: o.accent)[
        Question #counter(figure.where(kind: "question")).display(it.numbering)#if present(data.title) { [: #data.title] }
      ],
      if present(data.marks) { text(size: label-size, style: "italic", fill: monash-grey-dark)[#data.marks#if type(data.marks) in (int, float) { [ marks] }] }))
  if present(data.statement) {
    block(width: full, breakable: true, fill: monash-grey-light, inset: box-inset, above: zero, below: question-gap, data.statement)
  }
}
