#import "@preview/unofficial-monash-report:0.1.0": *
#show: report.with(title: [Long Contents], date: none, abstract: [#lorem(400)])
#for n in range(1, 25) [
  = A chapter title that is long enough to wrap across multiple lines in the contents: example #n
  == A subsection with a moderately long title
  Text for this chapter.
]
