// All visual constants live here. Values from the mock use 1 CSS px = .75pt.
#let monash-blue = rgb("006CAB")
#let monash-black = rgb("231F20")
#let monash-grey-dark = rgb("423F40")
#let monash-grey = rgb("666768")
#let monash-grey-mid = rgb("939598")
#let monash-grey-soft = rgb("D1D3D4")
#let monash-grey-light = rgb("EEF1F2")
#let body-fonts = ("STIX Two Text", "Libertinus Serif")
#let math-fonts = ("STIX Two Math", "New Computer Modern Math")
#let heading-fonts = ("Helvetica Neue", "Helvetica", "Arial", "Liberation Sans", "Libertinus Serif")
#let code-fonts = ("JetBrains Mono", "DejaVu Sans Mono")
// Typst has no font-enumeration API. Only name families known to be available.
#let embedded-fonts = ("Libertinus Serif", "New Computer Modern Math", "DejaVu Sans Mono")
#let available-fonts = sys.inputs.at("monash-fonts", default: embedded-fonts.join("|")).split("|")
#let resolve-font(value, stack) = if value != auto { value } else {
  stack.filter(family => family in available-fonts)
}
#let body-size = 11pt
#let cover-title-size = 33pt
#let assignment-title-size = 22pt
#let chapter-size = 21pt
#let section-size = 13pt
#let subsection-size = 11pt
#let label-size = 10.5pt
#let caption-size = 10pt
#let furniture-size = 9pt
#let byline-size = 10pt
#let code-size = 9pt
#let footnote-size = 9.5pt
#let subtitle-size = 14pt
#let doc-type-size = 12pt
#let unit-size = 10pt
#let light-weight = 300
#let body-leading = .8em // text bounds (.7em) + leading = 1.5em
#let paragraph-gap = 9.75pt
#let code-leading = .9em
#let zero = 0pt
#let full = 100%
#let margin-x = 25mm
#let margin-top = 27mm
#let margin-bottom = 25mm
#let hairline = .75pt
#let table-rule = 1.1pt
#let furniture-gap = 6pt
#let header-ascent = 12pt
#let footer-descent = 27pt
#let assignment-logo-height = 30pt
#let cover-logo-height = 42pt
#let title-gap = 22.5pt
#let byline-gap = 6pt
#let rule-gap = 12pt
#let first-question-gap = 25pt
#let cover-top = 60pt
#let cover-title-top = 255pt
#let cover-title-leading = .4em
#let title-leading = .45em
#let cover-gap = 12pt
#let cover-rule-gap = 10.5pt
#let cover-band = 10.5pt
#let field-label-width = 82pt
#let field-gap = 9pt
#let field-row-gap = 4.5pt
#let group-gap = 19.5pt
#let unit-tracking = .06em
#let notch-left = 17pt
#let notch-width = 7.5pt
#let notch-depth = 3.75pt
#let box-inset = (x: 12pt, y: 9pt)
#let question-gap = 9.75pt
#let question-above = 22.5pt
#let heading-above = 17.25pt
#let heading-below = 12.75pt
#let section-above = 17.25pt
#let section-below = 9.75pt
#let number-gap = 12pt
#let part-indent = 18pt
#let part-gap = 7.5pt
#let table-inset = (x: 6pt, y: 3.75pt)
#let abstract-inset = 30pt
#let abstract-gap = 7.5pt
#let contents-gap = 48pt
#let contents-indent = 19.5pt
#let contents-entry-gap = 3.75pt
#let contents-chapter-gap = 9pt
#let caption-gap = 6pt
#let code-inset = (x: 6pt, y: 7.5pt)
#let code-number-gap = 12pt
#let square-bullet-size = 3pt
#let footnote-rule-width = 90pt
// Internal example/test geometry also uses these tokens.
#let diagram-width = 322.5pt
#let diagram-height = 126pt
#let test-wide-width = 550pt
#let sample-figure-height = 42pt
#let stress-gap = 500pt
#let alternate-accent = monash-grey-dark
#let notch-rule() = layout(size => block(width: full, height: notch-depth, above: zero, below: zero,
  curve(
    curve.move((zero, zero)),
    curve.line((notch-left, zero)),
    curve.line((notch-left + notch-width / 2, notch-depth)),
    curve.line((notch-left + notch-width, zero)),
    curve.line((size.width, zero)),
    stroke: hairline + monash-grey-mid,
  ),
))
#let syntax-theme(accent) = bytes("<?xml version=\"1.0\" encoding=\"UTF-8\"?><plist version=\"1.0\"><dict><key>name</key><string>Academic</string><key>settings</key><array><dict><key>settings</key><dict><key>foreground</key><string>" + monash-black.to-hex() + "</string></dict></dict><dict><key>scope</key><string>keyword, storage</string><key>settings</key><dict><key>foreground</key><string>" + accent.to-hex() + "</string></dict></dict><dict><key>scope</key><string>comment</string><key>settings</key><dict><key>foreground</key><string>" + monash-grey.to-hex() + "</string></dict></dict></array></dict></plist>")
