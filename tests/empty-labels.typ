#import "@preview/unofficial-monash-report:0.1.0" as package
#let mode = sys.inputs.at("mode", default: "assignment")
#let options = {
  let options = (
    title: [Empty Labels],
    labels: (question: "", proof: [], tutor: "", mark: [], marks: "", abstract: [],
      keywords: "", contents: []),
  )
  if mode == "assignment" { options.tutor = [Staff] } else {
    options += (abstract: [Summary], keywords: ("Term",), outline: true)
  }
  options
}
#show: body => {
  show regex(".+"): it => { metadata((printed: it.text)); it }
  dictionary(package).at(mode)(..options, body)
}
= Chapter
#package.question(marks: 1)[Statement] <q>
#package.proof[Done]
@q
#context {
  let printed = query(metadata).filter(it => type(it.value) == dictionary)
    .filter(it => it.value.keys() == ("printed",)).map(it => it.value.printed).join("")
  for word in ("Question", "Tutor", "Proof", "mark", "Abstract", "Keywords", "Contents") {
    assert(not printed.contains(word), message: "hidden label: " + word)
  }
  assert(not printed.contains(":"), message: "empty labels must not leave a colon")
  assert(not printed.contains("."), message: "empty proof prefix must not leave a full stop")
}
