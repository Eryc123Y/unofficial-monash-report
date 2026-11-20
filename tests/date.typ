// Dates accept a datetime, `auto` (today), any text, or none.
#import "@preview/unofficial-monash-report:0.2.0": *
#let mode = sys.inputs.at("mode", default: "assignment")
#let opts = (title: [Dates], date: "13 November 2026", author: "Author")
#show: if mode == "report" { report.with(..opts) } else { assignment.with(..opts) }
A text date is printed as written.
#import "../src/options.typ": date-text
#assert.eq(date-text(datetime(year: 2026, month: 11, day: 1)), "1 November 2026")
#assert.eq(date-text(datetime(year: 2026, month: 11, day: 21)), "21 November 2026")
