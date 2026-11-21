// A long table in a figure breaks across pages, with its caption above the first part.
#import "@preview/unofficial-monash-report:0.2.0": *
#let mode = sys.inputs.at("mode", default: "assignment")
#show: if mode == "report" { report.with(title: [Long tables]) } else {
  assignment.with(title: [Long tables])
}
#let mark(name) = [#metadata(name)#label(name)]
Text before the table.
#figure(
  table(
    columns: 2, table.header[Row][Value],
    [#mark("first-row")0], [0], ..range(1, 120).map(i => ([#i], [#(i * i)])).flatten(),
    [#mark("last-row")120], [14400],
  ),
  caption: [A table longer than a page.#mark("caption")],
) <long-table>
Text after the table.#mark("after")
#context {
  let at(name) = locate(label(name)).position()
  let start = at("first-row").page
  assert(at("last-row").page > start, message: "the table did not break across pages")
  assert.eq(at("caption").page, start)
  assert(at("caption").y < at("first-row").y, message: "caption is not above the table")
  // The table starts on the page after the opening text only if nothing fits there.
  assert.eq(start, locate(<long-table>).page())
  assert.eq(at("after").page, at("last-row").page)
}
