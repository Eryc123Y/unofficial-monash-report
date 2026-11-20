// A labelled table outside a figure compiles and its label stays queryable.
#import "@preview/unofficial-monash-report:0.2.0": *
#let mode = sys.inputs.at("mode", default: "assignment")
#show: if mode == "report" { report.with(title: [Labels]) } else {
  assignment.with(title: [Labels])
}
#table(columns: 2, table.header[Name][Value], [a], [1]) <plain-table>
See the #link(<plain-table>)[table above].
#context {
  let found = query(<plain-table>)
  assert.eq(found.len(), 1)
  assert.eq(found.first().func(), table)
}
