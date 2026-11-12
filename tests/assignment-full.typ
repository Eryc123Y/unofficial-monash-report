#import "@preview/unofficial-monash-report:0.1.0": *
#import "../src/design.typ": *
#show: assignment.with(
  title: [Complete Assignment], author: [\[Your Name\]], student-id: [\[Student ID\]],
  unit: "UNIT0000 Example Unit", semester: [Semester 2, 2026], tutor: [\[Tutor Name\]],
  date: [13 November 2026], short-title: [Assignment], info: ([Extra information],),
  logo: image("assets/placeholder.svg"),
  font: "Libertinus Serif", heading-font: "Libertinus Serif", math-font: "New Computer Modern Math",
  code-font: "DejaVu Sans Mono", font-size: body-size, accent: monash-blue, paper: "a4", lang: "en",
)
#question(marks: 10, title: [Consistency])[Prove the result.] <q-first>
+ First part.
  + First nested part.
  + Second nested part.
+ Second part.
#lemma[An inequality][$ x^2 >= 0 $] <lemma-first>
#proof[Every square is non-negative.]
#figure(caption: [A listing.])[
```python
# A comment
def identity(value):
    return value
```
] <listing-first>
#figure(table(columns: 2, table.header[Input][Output], [1], [1]), caption: [A table.]) <table-first>
#figure(image("assets/placeholder.svg"), caption: [A neutral figure.]) <figure-first>
$ x+1=2 $ <equation-first>
#question(marks: [5 marks])
A heading-only question.
#question(number: 3)[Third statement.]
See @q-first, @lemma-first, @listing-first, @table-first, @figure-first and @equation-first.
