// Custom figure kinds restart in every chapter, like the built-in kinds.
#import "@preview/unofficial-monash-report:0.2.0": *
#import "../src/figures.typ": number-at
#show: report.with(title: [Custom kinds])
#let algo(caption) = figure(
  rect(width: 2cm, height: 1cm), kind: "algo", supplement: [Algorithm], caption: caption,
)
= One
#algo[First algorithm.] <alg-one>
#algo[Second algorithm.] <alg-two>
= Two
#algo[Third algorithm.] <alg-three>
#context {
  for (target, expected) in ((<alg-one>, "1.1"), (<alg-two>, "1.2"), (<alg-three>, "2.1")) {
    assert.eq(number-at((mode: "report"), query(target).first()), expected)
  }
}
See @alg-one and @alg-three.
