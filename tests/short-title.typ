// The automatic short title keeps word spaces and turns manual line breaks into spaces.
#import "../src/options.typ": validate, plain
#let short(unit, title) = validate("report", (unit: unit, title: title)).short-title
#assert.eq(short("FIT3162 Project", [Routing: A Study \ of Things]), "FIT3162 · Routing")
#assert.eq(short([FIT3162 Project], [A Study \ of Things]), "FIT3162 · A Study of Things")
#assert.eq(short(none, [An *emphasised* word]), "An emphasised word")
#assert.eq(short(none, ["Quoted" words]), "\"Quoted\" words")
#assert.eq(plain([Line one \ line two]), "Line one line two")
#assert.eq(plain([]), "")
Automatic short titles are plain text.
