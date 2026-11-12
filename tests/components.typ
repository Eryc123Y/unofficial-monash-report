#import "@preview/unofficial-monash-report:0.1.0": *
#import "../src/design.typ": *
#show: assignment.with(title: [Components])
#question(marks: 10)[Statement.] <q>
+ A part
  + A nested part
#lemma[Title][A lemma.] <lem>
#proof[An argument. $ x=1 $]
#figure(table(columns: 2, table.header[A][B], [one], [two], [three], [four]), caption: [A table.]) <tab>
#figure(rect(width: diagram-width, height: sample-figure-height), caption: [An image.]) <fig>
#figure(caption: [A program.])[
```python
def test():
    return 1 # comment
```
] <code>
$ x + 1 = 2 $ <eq>
See @q, @lem, @tab, @fig, @code and @eq.
