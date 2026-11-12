# unofficial-monash-report: requirements

A Typst package for Monash University STEM students with two document modes,
`assignment` and `report`. It is written from scratch. It replaces the unpublished
fork `Eryc123Y/assn-report-monash`; do not copy code from that fork.

The design is fixed. The source of truth for the look is the mock in `design/`
(five A4 pages as HTML, all sizes in CSS px, 1 px = 0.75 pt) and section 4 below.
Where the two disagree, section 4 wins.

Roles: the implementer builds the package to this document. Review and acceptance
are done separately against section 9.

## 1. Goals and non-goals

Goals

- One import gives a student a correct, good-looking assignment or report with
  no styling code of their own.
- Academic layout (serif body, justified text, three-line tables, plain theorem
  style) with a restrained Monash identity (Monash blue, light sans titles, sans
  running heads).
- Publishable on Typst Universe as a template package.

Non-goals

- No slides (that is `unofficial-monash-touying`).
- No thesis features: no parts, no list of figures, no glossary.
- No bundled Monash logo, crest or wordmark, in any file, at any size.
- No dependency on other Universe packages in `lib.typ`.

## 2. Repository

Model the layout on `unofficial-monash-slides-typst` (same author). Read its
`typst.toml`, `scripts/check.sh`, `.github/workflows/check.yml`, `tests/` and
README before starting, and follow the same conventions.

```
typst.toml            name "unofficial-monash-report", version "0.1.0",
                      compiler "0.15.0", license MIT, categories ["report"],
                      exclude docs, examples, scripts, tests, .github
lib.typ               public entrypoint: re-exports only
src/                  one concern per file, each under 300 lines
  design.typ          colours, font stacks, sizes, spacing (the only place
                      literal colours and sizes appear)
  options.typ         argument validation and defaults
  page.typ            margins, running head, footer
  headings.typ
  cover.typ           report cover
  titleblock.typ      assignment first-page title block
  question.typ        question, parts, marks
  theorems.typ        theorem-like environments and proof
  figures.typ         figure, table, listing, equation numbering and captions
  code.typ            code blocks
  assignment.typ      the `assignment` show-rule function
  report.typ          the `report` show-rule function
template/main.typ     starter document, imports `@preview/unofficial-monash-report:0.1.0`
template/assets/README.md   tells the user where to put their logo
examples/             assignment.typ, report.typ, group-report.typ
tests/                see section 8
scripts/check.sh      compiles everything through a temporary local package path,
                      fails on any error or warning
.github/workflows/check.yml
docs/preview/         PNGs used by the README
thumbnail.png
README.md, CHANGELOG.md, LICENSE
```

## 3. Public API

All names are kebab-case. Every argument is optional unless marked required. An
omitted optional argument produces no output and leaves no gap. Unknown or
wrongly typed arguments fail with a clear `panic` message that names the argument.

### 3.1 `assignment`

```typst
#show: assignment.with(
  title: [Assignment 2: Informed Search],   // required
  author: "Name",                           // str or content
  student-id: "12345678",
  unit: "FIT3080 Artificial Intelligence",  // shown top right, line 1
  semester: "Semester 2, 2026",             // shown top right, line 2
  tutor: "Name",
  date: none,                               // datetime, content, or none
  short-title: auto,                        // running head and footer text;
                                            // auto = unit code + title before ":"
  info: (),                                 // extra byline items: array of content
  logo: none,                               // content, usually image("logo.svg")
  font: auto, heading-font: auto, math-font: auto, code-font: auto,
  font-size: 11pt,
  accent: monash-blue,
  paper: "a4",
  lang: "en",
  labels: (:),                              // partial str/content wording overrides
  show-marks: true,                         // false hides every question's marks
  question-box: true,                       // false = plain statement, no fill or inset
)
```

### 3.2 `report`

```typst
#show: report.with(
  title: [Heuristic Search for Warehouse Robot Routing],  // required
  subtitle: none,
  unit: "FIT3162 · Computer Science Project",   // blue caps line above the title
  doc-type: none,                               // e.g. "Final Report"
  author: none, student-id: none,               // single author
  authors: (),                                  // group: array of dictionaries
                                                // (name:, student-id:, contribution:)
                                                // a non-empty `authors` replaces
                                                // author/student-id with a table
  supervisor: none,
  date: none,
  word-count: none,
  faculty: none, semester: none,                // top right of the cover
  info: (),                                     // extra rows: array of (label, value)
  logo: none,
  abstract: none, keywords: (),
  outline: false,                               // true opts into contents
  short-title: auto,
  labels: (:), show-marks: true, question-box: true,
  // font, heading-font, math-font, code-font, font-size, accent, paper, lang
  // as in `assignment`
)
```

### 3.3 Components (work in both modes)

- `question(marks: none, title: none, number: auto)[statement]` prints
  the configured question label and number, optional marks on the right, and
  the statement. `show-marks: false` hides all marks. Numeric 1 uses `labels.mark`;
  other numbers use `labels.marks`. Strings and content print as supplied.
  `question-box: false` gives plain text without fill, inset or box padding.
  It steps a counter; `number` overrides it. With no body it prints the heading
  only. It is referenceable (`@q-label` uses the configured label, for example "Problem 2").
- Parts of an answer are an ordinary Typst enum. Inside a document from this
  package the first enum level is numbered `(a)`, `(b)` and the second `(i)`,
  `(ii)`.
- `theorem`, `lemma`, `proposition`, `corollary`, `definition`, `example`,
  `remark`: each takes an optional positional title and a body. They share one
  counter. They are referenceable.
- `proof[...]` ends with a right-aligned `□`, also when the body ends in a
  display equation.
- `appendix(body)` switches level-1 numbering to `A`, `B`, ... (report only).
- Exported font dictionary: `monash-fonts`, with `font`, `heading-font`,
  `math-font` and `code-font` preference stacks for explicit opt-in.
- Exported design tokens: `monash-blue` and the greys in section 4.1.

`lib.typ` exports exactly these names. `tests/api.typ` checks each one resolves.

### 3.4 Wording and optional output

Both modes accept `labels: (:)`, merged over the defaults below. Each value
must be `str` or `content`. Only supplied keys change. Unknown keys panic with
`labels.<key>` in the message; wrong value types also name the key. Empty
strings/content hide a label without leaving its punctuation or separator.
Question, listing and theorem-like reference supplements use the same labels.
Native figure/table/equation supplements and bibliography titles remain
customisable through their native arguments.

```typst
labels: (
  question: "Question", marks: "marks", mark: "mark", tutor: "Tutor",
  author: "Author", student-id: "Student ID", contribution: "Contribution",
  supervisor: "Supervisor", date: "Date", word-count: "Word count",
  abstract: "Abstract", keywords: "Keywords", contents: "Contents", proof: "Proof",
  listing: "Listing", theorem: "Theorem", lemma: "Lemma", proposition: "Proposition",
  corollary: "Corollary", definition: "Definition", example: "Example", remark: "Remark",
)
```

`show-marks` and `question-box` must be booleans and default to `true` in both
modes. Everything except `title` is optional and prints nothing when unset.
Dates now default to `none` and contents to `false`; request them explicitly
with `date: datetime.today()` and `outline: true`. Empty arrays suppress
keywords and group-author rows. Omission must remove associated gaps, labels
and separators, including metadata rows and front-matter pages. The tests must
assert rendered output and positions rather than merely exercise compilation.

## 4. Design specification

### 4.1 Colour

| Token | Hex | Use |
|---|---|---|
| `monash-blue` | `#006CAB` | titles, numbers, labels, links, cover band, code keywords |
| `monash-black` | `#231F20` | body text, table rules |
| `monash-grey-dark` | `#423F40` | secondary text (marks, byline) |
| `monash-grey` | `#666768` | running head and footer text, line numbers |
| `monash-grey-mid` | `#939598` | hairlines |
| `monash-grey-soft` | `#D1D3D4` | reserved |
| `monash-grey-light` | `#EEF1F2` | question box fill |

`accent` replaces `monash-blue` everywhere. No other colours.

### 4.2 Type

Font stacks are fallback arrays so the package compiles on any machine, including
with `--ignore-system-fonts`:

- Body: `("STIX Two Text", "Libertinus Serif")`
- Math: `("STIX Two Math", "New Computer Modern Math")`
- Headings and page furniture: `("Helvetica Neue", "Helvetica", "Arial", "Liberation Sans", "Libertinus Serif")`
- Code: `("JetBrains Mono", "DejaVu Sans Mono")`

| Element | Font | Size | Weight | Colour |
|---|---|---|---|---|
| Body | body | 11pt, leading giving 1.5 line height | regular | black |
| Report cover title | heading | 33pt | light (300) | blue |
| Assignment title | heading | 22pt | light | blue |
| Level-1 heading (report), "Contents" | heading | 21pt | light | blue, number included |
| Level-2 heading | heading | 13pt | bold | black, number blue |
| Level-3 heading | heading | 11pt | bold | black, number blue |
| "Question N" | heading | 13pt | bold | blue |
| Marks | body | 10.5pt | italic | dark grey |
| Part labels `(a)` | heading | 10.5pt | bold | blue |
| Theorem label ("Lemma 1") | heading | 10.5pt | bold | blue |
| Caption label ("Figure 2.1.") | heading | 10pt | bold | blue |
| Caption text | body | 10pt | regular | black |
| Running head, footer | heading | 9pt | regular | grey |
| Code | code | 9pt, 1.6 line height | regular | black |
| Footnote | body | 9.5pt | regular | black |

Body paragraphs are justified with hyphenation on. No first-line indent;
paragraphs are separated by space. Headings are left-aligned.

### 4.3 Page

- A4. Left and right margins 25mm. Text block top about 27mm, bottom about 25mm.
- Running head (every page except the cover and the first page of an assignment):
  left and right text over a 0.75pt mid-grey hairline.
  - assignment: `short-title` left, "Author (Student ID)" right.
  - report: current level-1 heading with its number left, report title right.
- Footer (every page except the cover): 0.75pt mid-grey hairline, `short-title`
  left, page number right.
- Page numbers: assignment arabic from 1. Report: cover unnumbered, front matter
  (abstract, contents) lower-case roman, body arabic restarting at 1.

### 4.4 Assignment first page

Top row: logo left (height 30pt), `unit` and `semester` right in 9pt grey sans.
Then the title, then one byline in 10pt sans: author in bold black, followed by
student ID, "Tutor: ...", date and any `info` items, separated by " · ". Then a
0.75pt mid-grey rule carrying the notch (4.8). The first question starts 25pt
below the rule. With `logo: none` the right-hand unit block stays right-aligned
and the row keeps its height only if `unit` or `semester` is set.

### 4.5 Report cover

- Logo top left (height 42pt), `faculty` and `semester` top right.
- Title block starting about 30% down the page, left-aligned: `unit` in 10pt
  bold blue caps with 0.06em tracking; title; subtitle in 14pt italic serif,
  dark grey; a 0.75pt mid-grey rule with the notch; `doc-type` in 12pt serif.
- Bottom block, anchored 25mm above the bottom edge: the authors table when
  `authors` is non-empty (three-line table, italic header row: Author, Student
  ID, Contribution; the Contribution column is dropped when no author has one),
  then label and value rows (label in italic dark grey, 82pt wide): Author,
  Student ID, Supervisor, Date, Word count, then `info` rows, in that order,
  only those that are set.
- A solid blue band 10.5pt high across the full width at the bottom edge.

### 4.6 Report front matter and body

- Abstract: centred bold blue 10.5pt sans heading "Abstract", text indented 30pt
  on both sides, then "Keywords:" in bold followed by the list.
- Contents: level-1 entries bold with blue numbers and no leaders; level-2
  entries indented with dotted leaders; depth 2.
- Abstract and contents share one page when they fit.
- Level-1 headings do not force a page break.
- Equations, figures, tables, listings and theorem-like environments are numbered
  `chapter.n` and reset at each level-1 heading. In assignment mode they are
  numbered `n` through the document.

### 4.7 Components

- Question box: fill `monash-grey-light`, inset 9pt by 12pt, no stroke, no radius.
- Theorem-like environments: no box and no rule. Label, optional title in
  parentheses, full stop, then the body. Body italic for theorem, lemma,
  proposition and corollary; upright for definition, example and remark.
  Proof begins with italic "Proof."
- Tables: three-line style by default (1.1pt top and bottom rules, 0.75pt rule
  under the header, no vertical rules), caption above, centred.
- Figures: centred, caption below, centred.
- Code blocks: 0.75pt black rules above and below, right-aligned grey line
  numbers, no fill; syntax highlighting restricted to blue keywords and grey
  comments. Caption below, labelled "Listing". Inline code has no decoration.
- Display equations: centred, number right-aligned in parentheses.
- Lists: bullets are small filled squares.
- Links and references are blue, not underlined.

### 4.8 The notch

A small V cut into a horizontal rule: 7.5pt wide, 3.75pt deep, its left edge 17pt
from the left end of the rule, drawn with the rule's stroke. It appears exactly
twice in the package: under the assignment title block and under the report
cover title. Nowhere else.

## 5. Logo handling

- The package ships no Monash logo. `logo: none` is the default and every layout
  must look complete without one.
- `logo` accepts any content. The package scales it to the heights in 4.4 and
  4.5 and never recolours or distorts it.
- The template's `main.typ` has the logo line commented out with a one-line
  instruction, and `template/assets/README.md` repeats it.
- Tests and previews use a neutral placeholder image, never a Monash mark.

## 6. README

1. What it is, with three preview images (assignment first page, report cover,
   report body page), rendered without any Monash logo.
2. A notice near the top: unofficial, not affiliated with or endorsed by Monash
   University; no logo is included; users must obtain the logo themselves, are
   responsible for having the right to use it, and add it with `logo:`.
3. "Adding your logo": where to get the official file, where to put it, the one
   line to add, and Monash's basic usage rules (white background only, do not
   recolour, stretch or crop, keep clear space around it).
4. Quick start for each mode (`typst init` and a minimal document).
5. Argument tables for `assignment` and `report`, and a section per component.
6. Fonts: the stacks, what happens when a font is missing, how to override.
7. Design notes: colours follow Monash's published palette; the layout follows
   academic convention and is not a reproduction of the brand guidelines.

All code samples in the README must compile.

## 7. Engineering rules

- Typst 0.15.x. No warnings from `typst compile`.
- No literal colour or size outside `src/design.typ`.
- No personal data anywhere: placeholder names and IDs only.
- No state leaks: importing the package applies nothing until `assignment` or
  `report` is used.
- User `set` and `show` rules placed after the `#show:` line must still work.
- Conventional commits, no attribution lines, no emoji.

## 8. Tests

`scripts/check.sh` compiles every file under `tests/`, `examples/` and
`template/` and fails on any error or warning. It supports
`--ignore-system-fonts` and `--thumbnail` as in the slides repository. CI runs it
in both font modes.

Required test files:

- `api.typ`: every exported name resolves; bad arguments panic with the argument
  name in the message.
- `assignment-minimal.typ`: title only.
- `assignment-full.typ`: every argument, three questions, parts, a lemma and
  proof, a listing, a table, a figure, cross-references to each.
- `report-minimal.typ`: title only, `outline: false`.
- `report-full.typ`: every argument, abstract, contents, two chapters, an
  appendix, bibliography, footnotes.
- `report-group.typ`: three authors, one with no contribution.
- `cover-fields.typ`: each optional cover field on its own.
- `no-logo.typ` and `logo.typ` (placeholder image).
- `numbering.typ`: asserts equation, figure and theorem numbers in both modes
  and the roman-to-arabic page switch, using `context` queries.
- `stress.typ`: a very long title, a 60-character author name, a question whose
  statement crosses a page break, a table wider than the text block.
- `accent.typ`: a non-default `accent`.

## 9. Acceptance

The work is accepted when all of these hold:

1. `scripts/check.sh` and `scripts/check.sh --ignore-system-fonts` pass with no
   warnings.
2. `examples/assignment.typ` and `examples/report.typ` reproduce the content of
   the mock pages, and their PDFs match the mock in layout, type sizes, colours
   and spacing (compared page by page; differences of up to 2pt in position are
   acceptable, a different font fallback is not a failure).
3. Every optional argument can be omitted without leaving a gap or a stray
   separator.
4. `grep -ri` finds no Monash logo file, no embedded Monash mark in any image,
   and no personal name or student ID in the repository.
5. The notch appears only in the two places named in 4.8.
6. The README has all seven sections of section 6 and its samples compile.
7. No file under `src/` exceeds 300 lines and `lib.typ` contains only imports
   and re-exports.
8. The package passes the Typst Universe submission checks
   (`typst.toml` fields, template compiles from a fresh `typst init`, thumbnail
   present and under the size limit).

## 10. Deliverable

A new public repository `unofficial-monash-report` with the work on a feature
branch and a pull request into `main`. Do not publish to Typst Universe and do
not tag a release; that happens after review.
