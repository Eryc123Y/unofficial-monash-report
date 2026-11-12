#import "@preview/unofficial-monash-report:0.1.0" as package
#import "../src/labels.typ": default-labels
#let mode = sys.inputs.at("mode", default: "assignment")
#let field = sys.inputs.at("field", default: "tutor")
#let variant = sys.inputs.at("variant", default: "unset")
#let values = (
  tutor: [VALUE], student-id: [VALUE], unit: [VALUE], semester: [VALUE], date: [VALUE],
  abstract: [VALUE], keywords: ("VALUE",), outline: true, supervisor: [VALUE], word-count: 42,
  subtitle: [VALUE], doc-type: [VALUE], faculty: [VALUE], marks: 42,
)
#let unset = {
  if field == "keywords" { () } else if field == "outline" { false } else { none }
}
#let options = {
  let labels = (:)
  for key in default-labels.keys() { labels.insert(key, "UNWANTED-" + key) }
  labels.author = "Author"
  labels.question = "Question"
  let options = (
    title: [Required title], author: [Participant],
    font: "Libertinus Serif", heading-font: "Libertinus Serif",
    math-font: "New Computer Modern Math", code-font: "DejaVu Sans Mono",
    labels: labels,
  )
  if field != "marks" and variant != "baseline" {
    options.insert(field, if variant == "present" { values.at(field) } else { unset })
  }
  if variant == "hidden" { options.show-marks = false }
  options
}
#show: body => {
  show regex(".+"): it => {
    metadata((kind: "printed", text: it.text))
    it
  }
  show curve: it => { metadata((kind: "shape", text: "notch")); it }
  dictionary(package).at(mode)(..options, body)
}
#if field == "marks" {
  package.question(
    marks: if variant in ("present", "hidden") { values.marks } else { none },
  )[Statement]
}
#metadata((kind: "anchor", text: "body"))
Body
#pagebreak()
#metadata((kind: "anchor", text: "second-body"))
Body
