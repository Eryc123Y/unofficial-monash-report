#import "@preview/unofficial-monash-report:0.1.0" as package
#import "../src/labels.typ": default-labels
#let mode = sys.inputs.at("mode", default: "assignment")
#let group = sys.inputs.at("group", default: "false") == "true"
#let labels = {
  let labels = (:)
  for key in default-labels.keys() { labels.insert(key, "X-" + key) }
  labels.tutor = [X-tutor]
  labels
}
#let options = {
  let options = (
    title: [Labels], author: [Participant], student-id: [ID], unit: [Unit], semester: [Term],
    date: [Today], labels: labels,
  )
  if mode == "assignment" { options.tutor = [Staff] } else {
    options += (
      subtitle: [Subtitle], doc-type: [Type], faculty: [Faculty], supervisor: [Staff],
      word-count: 42, abstract: [Summary], keywords: ("Term",), outline: true,
    )
    if group { options.authors = ((name: [Participant], student-id: [ID], contribution: [Work]),) }
  }
  options
}
#show: body => {
  show regex(".+"): it => { metadata((printed: it.text)); it }
  dictionary(package).at(mode)(..options, body)
}
= Chapter
#package.question(marks: 1)[Statement] <q>
#package.question(marks: 2)[Statement]
#package.theorem[Body] <thm>
#package.lemma[Body] <lem>
#package.proposition[Body] <prop>
#package.corollary[Body] <cor>
#package.definition[Body] <def>
#package.example[Body] <ex>
#package.remark[Body] <rem>
#package.proof[Done]
#figure(raw("let x = 1", block: true), caption: [Code]) <listing>
@q @thm @lem @prop @cor @def @ex @rem @listing
#context {
  let printed = query(metadata).filter(it => type(it.value) == dictionary)
    .filter(it => it.value.keys() == ("printed",)).map(it => it.value.printed).join(" ")
    .replace(regex("\\s+"), " ")
  for key in ("question", "theorem", "lemma", "proposition", "corollary", "definition",
    "example", "remark", "listing") {
    assert(printed.matches(regex("X-" + key)).len() >= 2, message: "heading and ref: " + key)
  }
  assert(printed.contains("1 X-mark"), message: "singular numeric mark")
  assert(printed.contains("2 X-marks"), message: "plural numeric marks")
  assert(not printed.contains("1 X-marks"), message: "singular must not use plural")
  assert(printed.contains("X-proof"), message: "proof label")
  if mode == "assignment" { assert(printed.contains("X-tutor")) } else {
    for key in ("author", "student-id", "supervisor", "date", "word-count", "abstract",
      "keywords", "contents") { assert(printed.contains("X-" + key), message: key) }
    if group { assert(printed.contains("X-contribution")) }
  }
}
