#import "design.typ": *
#let code-style(o, body) = {
  set raw(theme: syntax-theme(o.accent))
  show raw: set text(font: o.code-font, size: code-size)
  show raw.where(block: true): it => block(
    above: paragraph-gap, width: full, breakable: true,
    stroke: (top: hairline + monash-black, bottom: hairline + monash-black), inset: code-inset,
  )[
    #set text(
      font: o.code-font, top-edge: code-top-edge, bottom-edge: code-bottom-edge, size: code-size,
    )
    // The text edges make every line, wrapped or not, exactly one code line high.
    // Rows grow with wrapped lines; the line number keeps empty lines at full height.
    #set par(justify: false, leading: zero)
    #grid(
      columns: (auto, 1fr), column-gutter: code-number-gap, row-gutter: zero,
      ..it.lines.map(l => (
        align(right, text(
          font: o.code-font, size: code-size, fill: monash-grey, str(l.number),
        )),
        align(left, text(size: code-size, l.body)),
      )).flatten(),
    )
  ]
  body
}
