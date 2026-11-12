#import "@preview/unofficial-monash-report:0.1.0": *
#import "../src/design.typ": diagram-width, diagram-height, schematic-svg

#show: report.with(
  logo: image("../tests/assets/placeholder.svg"),
  title: [Heuristic Search for Warehouse Robot Routing],
  subtitle: [A comparison of A\*, weighted A\* and jump point search on grid maps],
  unit: "FIT3162 · Computer Science Project",
  author: [\[Your Name\]], student-id: [\[Student ID\]],
  date: datetime(year: 2026, month: 11, day: 13),
  short-title: [FIT3162 · Final Report],
  abstract: [
    Warehouse robots plan thousands of short routes an hour, so the cost of
    each search matters as much as the length of the path it returns. This
    report compares A\*, weighted A\* and jump point search on grid maps of
    increasing size. We measure nodes expanded, running time and path cost,
    and we show where the weighted variant trades optimality for speed.
    \[Summarise your main result here in one or two sentences.\]
  ],
  keywords: ("heuristic search", "A*", "path planning", "grid maps"),
)

= Introduction
This example preserves the contents and page locations shown in the design
mock. The remaining pages are editable placeholders for a student's report.

== Problem statement
\[Describe the route-planning problem, its inputs and its objectives.\]

#pagebreak()
== Contributions
\[List the contributions supported by your experiments.\]

#pagebreak()
= Background
A route-planning problem is a graph whose nodes are robot positions and whose
edges are single moves with non-negative cost. A search algorithm is
_optimal_ if the first path it returns to the goal is a cheapest one. This
section fixes the notation used in the rest of the report.

== Best-first search
Best-first search keeps a frontier of discovered nodes and always expands
the one with the smallest evaluation $f(n)$. A\* uses the cost so far plus an
estimate of the cost to go @search-source:

$ f(n) = g(n) + h(n). $ <eq-evaluation>

#definition[Admissible heuristic][
  A heuristic $h$ is _admissible_ if $h(n) <= h^*(n)$ for every node $n$,
  where $h^*(n)$ is the cost of a cheapest path from $n$ to a goal.
] <def-admissible>

With an admissible heuristic A\* is optimal, and a better-informed heuristic
expands fewer nodes.#footnote[
  A heuristic $h_2$ is better informed than $h_1$ if $h_2(n) >= h_1(n)$ at
  every node.
] @fig-expansions sketches the effect as the map grows.

#figure(
  image(schematic-svg, width: diagram-width, height: diagram-height),
  caption: [Nodes expanded as the map grows (schematic).],
) <fig-expansions>

== Admissible and consistent heuristics
Consistency is the stronger condition. It bounds how fast $h$ may fall along
an edge, and it lets A\* close each node the first time it is expanded.

#pagebreak()
\[Extend the discussion of admissibility and consistency.\]
#pagebreak()
\[Discuss the assumptions used in the comparison.\]
#pagebreak()
= Method
== Map generation
\[Describe how the maps were generated.\]
#pagebreak()
== Implementation
\[Describe the implementation.\]
#pagebreak()
\[Give reproducibility details.\]
#pagebreak()
= Results
\[Report the measured results.\]
#pagebreak()
\[Add results for larger maps.\]
#pagebreak()
\[Add uncertainty and variation across runs.\]
#pagebreak()
= Discussion
\[Discuss the observed trade-offs.\]
#pagebreak()
\[Discuss limitations.\]
#pagebreak()
= Conclusion
\[Summarise what the evidence supports.\]
#pagebreak()
#bibliography("assets/references.yml", style: "ieee", title: [References])
#pagebreak()
#appendix[
  = Additional experiments
  \[Add supplementary experiments.\]
]
