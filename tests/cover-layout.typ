// The report cover keeps the unit, title, subtitle and author details apart when
// they are long.
#import "@preview/unofficial-monash-report:0.2.0": *
#let mark(name) = box(width: 0pt, height: 0pt) + [#metadata(name)#label(name)]
#show: report.with(
  title: [#mark("title-start")An Empirical Study of Heuristic Search Algorithms for
    Large-Scale Multi-Robot Warehouse Routing Under Uncertainty#mark("title-end")],
  unit: [FIT3162 Computer Science Project and a Very Long Unit Name That Goes On and On
    Past One Line of the Cover, and Then On Past a Second Line of the Cover As Well
    #mark("unit-end")],
  labels: (author: [#mark("table-top")Author]),
  subtitle: [A subtitle that is also rather long and will need to wrap onto a second line
    of the cover page#mark("subtitle-end")],
  authors: range(8).map(i => (
    name: [#if i == 0 { mark("authors-start") }Author Number #i],
    student-id: "1234567" + str(i),
    contribution: "Did part " + str(i) + " of the work and wrote it up",
  )),
  supervisor: [#mark("fields-start")Dr Someone], date: "1 November 2026", word-count: 5000,
  faculty: "Faculty of Information Technology", semester: "Semester 2, 2026",
  doc-type: [Final Report#mark("doc-type-end")],
)
Body text.
#context {
  let at(name) = locate(label(name)).position()
  let before(a, b) = assert(
    at(a).page < at(b).page or at(a).page == at(b).page and at(a).y < at(b).y,
    message: a + " must come before " + b + ": " + repr((at(a), at(b))),
  )
  // The title's first baseline sits at least the cover gap plus the title's ascent
  // below the unit's last baseline, and the author table header a line below the
  // document type.
  let gap(a, b) = at(b).y - at(a).y
  assert(gap("unit-end", "title-start") > 35pt, message: "unit runs into the title")
  before("title-end", "subtitle-end")
  before("subtitle-end", "doc-type-end")
  assert(
    at("doc-type-end").page < at("table-top").page or gap("doc-type-end", "table-top") > 20pt,
    message: "author table runs into the title block",
  )
  before("table-top", "authors-start")
  before("authors-start", "fields-start")
}
