#import "@preview/unofficial-monash-report:0.1.0": *
#import "../src/design.typ": *
#let mode = sys.inputs.at("mode", default: "assignment")
#let options = (
  title: [A Very Long Title That Continues Across Several Lines to Test the Layout of Assignments and Report Covers Without Overlapping Other Content],
  author: "Placeholder Author " + "X" * 41,
  student-id: [\[Student ID\]], date: none,
)
#assert.eq(options.author.len(), 60)
#show: if mode == "report" { report.with(..options, outline: false) } else { assignment.with(..options) }
#question[This long statement must continue over multiple pages. #lorem(900)] <long-question>
Answer after the question.
#figure(table(columns: (test-wide-width / 2, test-wide-width / 2), table.header[Wide][Table], [First], [Second]), caption: [A deliberately wide table.])
