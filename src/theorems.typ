#import "design.typ": *
#import "options.typ": require, valid-text, present
#import "page.typ": current-config
#let chapter-number() = {
  let hs = query(heading.where(level: 1).before(here()))
  if hs.len() == 0 { "0" } else { numbering(if hs.last().numbering == "A.1" { "A" } else { "1" }, counter(heading).get().first()) }
}
#let statement(kind, ..args) = {
  for key in args.named().keys() { panic("unknown argument `" + key + "`") }
  let items = args.pos()
  require("body", items.len() in (1, 2) and items.all(valid-text), "one body, or a title and a body")
  let title = if items.len() == 2 { items.first() }
  figure(metadata((title: title, statement: items.last(), kind: kind)), kind: "theorem", supplement: kind,
    numbering: n => context {
      let o = current-config()
      if o.mode == "report" { chapter-number() + "." + str(n) } else { str(n) }
    })
}
#let theorem = statement.with("Theorem")
#let lemma = statement.with("Lemma")
#let proposition = statement.with("Proposition")
#let corollary = statement.with("Corollary")
#let definition = statement.with("Definition")
#let example = statement.with("Example")
#let remark = statement.with("Remark")
#let show-statement(it) = context {
  let o = current-config()
  set align(left)
  let data = it.body.value
  block(breakable: true, above: paragraph-gap, below: paragraph-gap)[
    #text(font: o.heading-font, size: label-size, weight: "bold", fill: o.accent)[#data.kind #counter(figure.where(kind: "theorem")).display(it.numbering)]#if present(data.title) { [ (#data.title)] }.
    #if data.kind in ("Theorem", "Lemma", "Proposition", "Corollary") { emph(data.statement) } else { data.statement }
  ]
}
#let proof(body, ..args) = {
  for key in args.named().keys() { panic("unknown argument `" + key + "`") }
  require("body", type(body) in (str, content), "str or content")
  block(breakable: true)[#emph[Proof.] #body #h(1fr)□]
}
