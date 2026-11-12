#import "@preview/unofficial-monash-report:0.1.0" as package
#import "../src/design.typ": invalid-relative-size
#let documented = (
  "assignment", "report", "question", "theorem", "lemma", "proposition", "corollary",
  "definition", "example", "remark", "proof", "appendix", "monash-blue", "monash-black",
  "monash-grey-dark", "monash-grey", "monash-grey-mid", "monash-grey-soft", "monash-grey-light",
)
#assert.eq(dictionary(package).keys().sorted(), documented.sorted())
#for name in documented {
  assert(type(dictionary(package).at(name)) == if name.starts-with("monash-") { color } else { function }, message: name)
}
// check.sh also compiles this file once per invalid argument and checks panic text.
#let bad = sys.inputs.at("bad", default: "none")
#let mode = sys.inputs.at("mode", default: "assignment")
#let invalid = (
  title: 42, author: 42, student-id: 42, unit: 42, semester: 42, date: "today",
  short-title: 42, info: false, logo: "logo.svg", font: 42, heading-font: (42,),
  math-font: false, code-font: (), font-size: -1, accent: "blue", paper: 42, lang: 42,
  tutor: 42, subtitle: 42, doc-type: 42, authors: 42, supervisor: 42,
  word-count: -1, faculty: 42, abstract: 42, keywords: (42,), outline: "yes",
)
#if bad != "none" {
  if mode in ("assignment", "report") {
    let opts = (title: [API])
    if bad == "missing-title" { opts = (:) }
    else if bad == "unknown" { opts.insert("unknown-argument", true) }
    else if bad == "relative-size" { opts.insert("font-size", invalid-relative-size) }
    else if bad == "bad-paper" { opts.insert("paper", "not-a-paper") }
    else if bad == "info-item" { opts.insert("info", (42,)) }
    else if bad == "author-key" { opts.insert("authors", ((name: [Author], extra: [Invalid]),)) }
    else { opts.insert(bad, invalid.at(bad)) }
    dictionary(package).at(mode)(..opts, [])
  } else if mode == "question" {
    let values = (marks: false, title: false, number: "two", body: 42, unknown: true)
    if bad == "body" { package.question(42) }
    else { package.question(..((bad): values.at(bad))) }
  } else if mode == "appendix" {
    package.appendix[Wrong mode.]
  } else {
    dictionary(package).at(mode)(unknown: true, [Body])
  }
}
Public names resolve exactly, with no style applied on import.
