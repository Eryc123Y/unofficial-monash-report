#import "@preview/unofficial-monash-report:0.1.0": *
#show: report.with(title: [Native Overrides], date: none, outline: false)
#set figure(numbering: "i")
#set math.equation(numbering: "(i)")
#figure([An unnumbered illustration.], numbering: none, caption: [Only the caption text.])
#figure([Custom numbering.], caption: [Roman numbering.]) <custom-figure>
$ x=1 $ <custom-equation>
See @custom-figure, @custom-equation and #ref(<custom-figure>, form: "page").
#question(number: 5)
#question(title: [Heading only]) <question-six>
#context { assert.eq(counter(figure.where(kind: "question")).at(<question-six>).first(), 6) }
