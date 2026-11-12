#import "@preview/unofficial-monash-report:0.1.0" as package
#import "../src/design.typ": box-inset, zero, monash-grey-light
#let mode = sys.inputs.at("mode", default: "assignment")
#let hidden = sys.inputs.at("hidden", default: "false") == "true"
#let box = sys.inputs.at("box", default: "true") == "true"
#show: body => {
  show regex(".+"): it => { metadata((printed: it.text)); it }
  show block: it => {
    if it.fill == monash-grey-light { metadata((question-fill: true)) }
    it
  }
  dictionary(package).at(mode)(
    title: [Options],
    show-marks: not hidden, question-box: box, body,
  )
}
#package.question(marks: 1)[Statement] <q>
#package.question(marks: 2)
#package.question(marks: "STRING")
#package.question(marks: [EXPLICIT])
#context {
  let printed = query(metadata).filter(it => type(it.value) == dictionary)
    .filter(it => it.value.keys() == ("printed",)).map(it => it.value.printed).join(" ")
    .replace(regex("\\s+"), " ")
  assert.eq(printed.contains("1 mark"), not hidden)
  assert.eq(printed.contains("2 marks"), not hidden)
  assert(not printed.contains("1 marks"), message: "singular English mark")
  assert.eq(printed.contains("EXPLICIT"), not hidden)
  assert.eq(printed.contains("STRING"), not hidden)
  assert.eq(query(metadata).any(it => it.value == (question-fill: true)), box)
  let statement = query(metadata).find(it => it.value == (printed: "Statement"))
  let heading = query(metadata).find(it => type(it.value) == dictionary and
    it.value.at("printed", default: "").starts-with("Question"))
  // Plain statements start at the heading's left edge; boxed ones have an inset.
  let dx = statement.location().position().x - heading.location().position().x
  assert.eq(dx, if box { box-inset.x } else { zero })
  metadata((question-metrics: (
    x: dx.pt(), y: (statement.location().position().y - heading.location().position().y).pt(),
  )))
}
