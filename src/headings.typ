#import "design.typ": *
#let heading-style(o, body) = {
  set heading(numbering: "1.1")
  show heading: it => {
    let major = it.level == 1
    block(above: if major { heading-above } else { section-above },
      below: if major { heading-below } else { section-below }, sticky: true)[
      #set text(font: o.heading-font,
        size: if major { chapter-size } else if it.level == 2 { section-size } else { subsection-size },
        weight: if major { light-weight } else { "bold" },
        fill: if major { o.accent } else { monash-black })
      #set par(justify: false, leading: title-leading)
      #context {
        if it.numbering != none {
          text(fill: o.accent, counter(heading).display(it.numbering))
          h(number-gap)
        }
        it.body
      }
    ]
  }
  body
}
