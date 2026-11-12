#import "@preview/unofficial-monash-report:0.1.0": *
#let mode = sys.inputs.at("mode", default: "assignment")
#let opts = (title: [Neutral Placeholder], logo: image("assets/placeholder.svg"), date: none)
#show: if mode == "report" { report.with(..opts, outline: false) } else { assignment.with(..opts) }
The image is a neutral geometric placeholder.
