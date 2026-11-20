// A wide logo is scaled to fit its column rather than to the logo height alone.
#import "@preview/unofficial-monash-report:0.2.0": *
#import "../src/cover.typ": logo-box
#show: report.with(
  title: [Wide logo], logo: rect(width: 12cm, height: 1cm), faculty: "Faculty", semester: "S2",
)
Body text.
#context {
  let wide = rect(width: 12cm, height: 1cm)
  // Scaled to the 200pt column, a 12:1 logo is 200pt / 12 high, not 42pt.
  let size = measure(block(width: 200pt, logo-box(wide, 42pt)))
  assert(calc.abs((size.height - 200pt / 12).pt()) < .01, message: repr(size))
  let tall = measure(block(width: 200pt, logo-box(rect(width: 1cm, height: 2cm), 42pt)))
  assert(calc.abs((tall.height - 42pt).pt()) < .01, message: repr(tall))
}
