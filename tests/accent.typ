#import "@preview/unofficial-monash-report:0.1.0": *
#import "../src/design.typ": alternate-accent
#show: report.with(title: [Accent Override], accent: alternate-accent, outline: true,
  abstract: [All accent elements use the supplied colour.])
= Heading
== Subheading
#question(marks: 5)[Statement.]
#theorem[A theorem.]
#figure(caption: [Code.])[
```python
def f():
    return True # comment
```
]
#link("https://example.org")[A link].
