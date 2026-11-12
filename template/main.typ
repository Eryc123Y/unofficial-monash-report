#import "@preview/unofficial-monash-report:0.1.0": *

#show: assignment.with(
  // Opt into the preferred stacks; missing font families produce warnings.
  // ..monash-fonts,
  title: [Assignment Title],
  author: [\[Your Name\]],
  student-id: [\[Student ID\]],
  unit: "UNIT0000 Example Unit",
  // Obtain an authorised logo, put it in assets/, then uncomment this line:
  // logo: image("assets/logo.svg"),
)

#question(marks: 10)[Replace this with the question statement.]

+ Write the first part of your answer here.
+ Write the second part here.

#lemma[Example result][State a result you need.]
#proof[Give its proof.]
