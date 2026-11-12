#import "@preview/unofficial-monash-report:0.1.0": *
#let field = sys.inputs.at("field", default: "subtitle")
#let values = (
  subtitle: [Subtitle], unit: [Unit], doc-type: [Report], author: [\[Your Name\]],
  student-id: [\[Student ID\]], supervisor: [\[Supervisor Name\]],
  date: [13 November 2026], word-count: 1200, faculty: [Faculty], semester: [Semester],
  info: (([Label], [Value]),),
  authors: ((name: [\[Author 1\]], student-id: [\[Student ID\]]), (name: [\[Author 2\]])),
)
#show: report.with(title: [Single Optional Field], outline: false,
  ..((date: none) + ((field): values.at(field))))
Body.
