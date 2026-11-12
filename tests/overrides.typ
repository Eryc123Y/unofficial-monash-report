#import "@preview/unofficial-monash-report:0.1.0": *
#import "../src/design.typ": *
// Importing the library leaves all native text, page and heading settings alone.
#context {
  assert.eq(text.fill, black)
  assert.eq(heading.numbering, none)
}
#show: assignment.with(title: [Local Overrides], date: none)
#set text(size: subtitle-size)
#show heading: it => [CUSTOM #it.body]
#context { assert.eq(text.size, subtitle-size) }
= User heading
A user set rule and show rule after the package remain effective.
