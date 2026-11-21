// A floating figure leaves no extra space at the point where it was written.
#import "@preview/unofficial-monash-report:0.2.0": *
#let mode = sys.inputs.at("mode", default: "assignment")
#show: if mode == "report" { report.with(title: [Floats]) } else {
  assignment.with(title: [Floats])
}
#let mark(name) = [#box(width: 0pt)#label(name)]
Control paragraph one.#mark("c1")

Control paragraph two.#mark("c2")

Before the image.#mark("image-before")

#figure(rect(width: 2cm, height: 1cm), caption: [Floating image.], placement: top)

After the image.#mark("image-after")

Before the table.#mark("table-before")

#figure(table(columns: 1, [Cell]), caption: [Floating table.], placement: top)

After the table.#mark("table-after")

Before the listing.#mark("raw-before")

#figure(raw("x = 1", block: true), caption: [Floating listing.], placement: bottom)

After the listing.#mark("raw-after")
#context {
  let at(name) = locate(label(name)).position()
  let pitch(a, b) = at(b).y - at(a).y
  for kind in ("image", "table", "raw") {
    assert(
      calc.abs((pitch(kind + "-before", kind + "-after") - pitch("c1", "c2")).pt()) < .01,
      message: kind + " float left space behind",
    )
  }
}
