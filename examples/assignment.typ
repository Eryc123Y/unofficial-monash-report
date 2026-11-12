#import "@preview/unofficial-monash-report:0.1.0": *
#import "../src/design.typ": example-table-width
#show: assignment.with(
  logo: image("../tests/assets/placeholder.svg"),
  title: [Assignment 2: Informed Search],
  author: [\[Your Name\]], student-id: [\[Student ID\]],
  tutor: [\[Tutor Name\]], unit: "FIT3080 Artificial Intelligence",
  semester: "Semester 2, 2026", date: datetime(year: 2026, month: 11, day: 13),
)

#question(marks: 10)[
  Let $h$ be a heuristic on a graph with non-negative edge costs $c(n, n')$.
  (a) Show that if $h$ is consistent and $h(g) = 0$ at every goal $g$, then $h$ is
  admissible. (b) Give a heuristic that is admissible but not consistent.
] <q-consistency>

+ Write $h^*(n)$ for the cost of a cheapest path from $n$ to a goal.
  Consistency says that the heuristic never drops by more than the cost of
  the edge just taken:

  $ h(n) <= c(n, n') + h(n') quad "for every edge" (n, n'). $ <eq-consistency>

  #lemma[Consistency implies admissibility][
    If $h$ satisfies #ref(<eq-consistency>, supplement: none) and $h(g) = 0$ at
    every goal $g$, then $h(n) <= h^*(n)$ for every node $n$.
  ] <lem-admissible>

  #proof[
    Induct on the number $k$ of edges on a cheapest path from $n$ to a goal.
    If $k = 0$ then $n$ is a goal and $h(n) = 0 = h^*(n)$. Otherwise let $n'$
    be the next node on that path, so that $h^*(n) = c(n, n') + h^*(n')$ and
    $n'$ has a cheapest path of $k - 1$ edges. \
    By
    #ref(<eq-consistency>, supplement: none) and the induction hypothesis,
    #math.equation(block: true, numbering: none)[
      $ h(n) <= c(n, n') + h(n') <= c(n, n') + h^*(n') = h^*(n). $
    ]
  ]
+ Take the path $s -> a -> g$ with both edges of cost 1, and set
  $h(s) = 2$, $h(a) = 0$, $h(g) = 0$. Every value is at most the true remaining
  cost, so $h$ is admissible. On the edge $(s, a)$, however,
  #ref(<eq-consistency>, supplement: none) would need $2 <= 1 + 0$, which is
  false, so $h$ is not consistent.

#pagebreak()
#question(marks: 15)[
  Implement A\* search on a grid with 4-connected moves, and compare the
  Manhattan heuristic with the zero heuristic on the three supplied maps.
] <q-implementation>

@listing-search gives the search loop. The frontier is a binary heap ordered
by $f = g + h$, and a node is skipped when it is popped with a cost worse
than the best one already recorded.

#figure(caption: [A\* search with a binary-heap frontier.])[
```python
def astar(start, goal, h):
    frontier = [(h(start), 0, start)]
    best = {start: 0}
    while frontier:
        f, g, node = heappop(frontier)
        if node == goal:
            return g
        if g > best[node]:
            continue            # stale entry
        for nxt, cost in neighbours(node):
            if g + cost < best.get(nxt, inf):
                best[nxt] = g + cost
                heappush(frontier, (g + cost + h(nxt), g + cost, nxt))
```
] <listing-search>

@table-search reports the number of nodes expanded. Both heuristics return
the same path cost on every map, as @lem-admissible guarantees; the Manhattan
heuristic expands far fewer nodes.

#figure(
  block(width: example-table-width, table(columns: (1.13fr, .85fr, 1.5fr, 1.2fr, .9fr),
    table.header[Map][Size][Zero heuristic][Manhattan][Path cost],
    [\[Map A\]], [\[size\]], [\[count\]], [\[count\]], [\[cost\]],
    [\[Map B\]], [\[size\]], [\[count\]], [\[count\]], [\[cost\]],
    [\[Map C\]], [\[size\]], [\[count\]], [\[count\]], [\[cost\]],
  )), caption: [Nodes expanded and path cost on each map.],
) <table-search>

#question(marks: 5)[
  State the worst-case time complexity of A\* with the zero heuristic on a
  graph with $V$ nodes and $E$ edges.
] <q-complexity>

With $h = 0$ the algorithm is Dijkstra's. Each edge causes at most one push,
so the heap holds at most $E$ entries and every push or pop costs
$O(log E) = O(log V)$. The total is $O((V + E) log V)$.
