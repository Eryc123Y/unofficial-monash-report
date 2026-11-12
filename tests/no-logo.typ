#import "@preview/unofficial-monash-report:0.1.0": *
#let mode = sys.inputs.at("mode", default: "assignment")
#show: if mode == "report" { report.with(title: [No Logo], date: none, outline: false) } else { assignment.with(title: [No Logo], date: none) }
A complete layout without a logo or byline.
