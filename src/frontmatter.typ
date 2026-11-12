#import "design.typ": *
#import "options.typ": present
#let frontmatter(o) = {
  if present(o.abstract) or o.keywords.len() > 0 {
    pad(x: abstract-inset)[
      #if present(o.abstract) {
        align(center, text(font: o.heading-font, size: label-size, weight: "bold", fill: o.accent)[Abstract])
        v(abstract-gap)
        o.abstract
      }
      #if o.keywords.len() > 0 { parbreak(); strong[Keywords:]; [ ]; o.keywords.join(", ") }
    ]
  }
  if o.outline {
    if present(o.abstract) or o.keywords.len() > 0 { v(contents-gap) }
    show outline.entry: it => {
      let major = it.level == 1
      set text(weight: if major { "bold" } else { "regular" })
      block(above: if major { contents-chapter-gap } else { contents-entry-gap }, below: zero)[
        #pad(left: if major { zero } else { contents-indent })[
          #link(it.element.location())[
            #box(if major { text(fill: o.accent, it.prefix()) } else { it.prefix() })
            #h(furniture-gap)#it.element.body
            #if major { h(1fr) } else { box(width: 1fr, repeat[.]) }
            #h(furniture-gap)#it.page()
          ]
        ]
      ]
    }
    outline(title: [Contents], depth: 2, indent: zero)
  }
}
