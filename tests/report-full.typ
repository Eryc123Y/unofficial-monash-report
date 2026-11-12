#import "@preview/unofficial-monash-report:0.1.0": *
#import "../src/design.typ": *
#show: report.with(
  title: [Complete Report], subtitle: [Subtitle], unit: [UNIT0000 · Example Unit], doc-type: [Final Report],
  author: [\[Your Name\]], student-id: [\[Student ID\]], authors: (),
  supervisor: [\[Supervisor Name\]], date: datetime(year: 2026, month: 11, day: 13),
  word-count: 1200, faculty: [Example Faculty], semester: [Semester 2, 2026],
  info: (([Project], [Example project]),), logo: image("assets/placeholder.svg"),
  abstract: [An abstract with enough text to test the shared abstract and contents page.],
  keywords: ("first", "second"), outline: true, short-title: [Report],
  font: "Libertinus Serif", heading-font: "Libertinus Serif", math-font: "New Computer Modern Math",
  code-font: "DejaVu Sans Mono", font-size: body-size, accent: monash-blue, paper: "a4", lang: "en",
)
= Introduction
== Setting
This is a sentence with a footnote.#footnote[A footnote.] Here is a citation @search-source.
$ a=b $ <equation>
#theorem[First theorem.]
#lemma[Second statement with a shared counter.] <helper>
#proof[An argument ending with a display equation. $ a=b $]
= Results
$ c=d $
#definition[A definition.]
#proposition[A proposition.]
#corollary[A corollary.]
#example[An example.]
#remark[A remark.]
See @equation and @helper.
#bibliography("../examples/assets/references.yml", style: "ieee")
#appendix[
  = Supplement
  $ x=y $
  #theorem[An appendix theorem.]
]
