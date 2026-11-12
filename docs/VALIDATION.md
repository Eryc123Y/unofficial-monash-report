# Local validation: 0.1.0

Validated with `typst 0.15.1 (unknown commit)` on `feat/initial-package`.

## Commands

Final checks (each exits 0 with no compiler errors or warnings):

```sh
scripts/check.sh
scripts/check.sh --ignore-system-fonts
scripts/check.sh --thumbnail
```

The first two logs are `build/round-2-check-system-fonts.log` and
`build/round-2-check-embedded-fonts.log`. Each run reports 165 successful checks,
including expected invalid-argument failures. The thumbnail run also renders
both complete examples to PNG at 96 PPI in `build/preview/`, copies the three
README previews to `docs/preview/`, and renders the starter at 100 PPI for
`thumbnail.png`. Expected panics are checked for the offending argument;
they are not compiler warnings being ignored.

The PNG render commands used by the script are equivalent to:

```sh
export TYPST_PACKAGE_PATH="$PWD/build/packages"
typst compile --root . --input "monash-fonts=$(typst fonts | tr '\n' '|')" --ppi 96 examples/assignment.typ 'build/preview/assignment-{p}.png'
typst compile --root . --input "monash-fonts=$(typst fonts | tr '\n' '|')" --ppi 96 examples/report.typ 'build/preview/report-{p}.png'
```

`build/packages/preview/unofficial-monash-report/0.1.0` is the development
symlink to this checkout. The check script itself uses and cleans a separate
temporary package path. Its fresh-init check copies only shippable files to
an isolated package directory before running `typst init` and compiling.

An additional direct compile, without a font inventory, also passes:

```sh
TYPST_PACKAGE_PATH="$PWD/build/packages" typst compile --root . --ignore-system-fonts build/fresh-init/main.typ build/fresh-init-portable.pdf
```

## Section 9 acceptance

| Item | Local result | Evidence |
| --- | --- | --- |
| 1. Both font modes, no warnings | PASS | Both required commands exit 0. Every diagnostic fails the script. |
| 2. Mock content and visual layout | PASS, with the precedence decisions below | Assignment is 2 A4 pages. Report is 18 A4 pages, preserving the mock's contents destinations with editable placeholders on unspecified pages. Both assignment pages, report cover, combined front matter and Background page were rendered and visually compared against the five HTML mocks. Code/table row heights, title wrapping, rules, question boxes, heading spacing and footer positions were adjusted against those views. |
| 3. Omitted optional arguments leave no gaps/separators | PASS | Rendered assertions cover all 14 requested fields in 19 mode/field combinations. Explicit unset values match omitted baselines in printed text, page counts, shape positions and body anchors, with a visible positive control for every field. Pinned baselines reject leftover gaps, labels and separators. Hidden marks also match absent marks. |
| 4. No Monash marks or personal details | PASS | All committed image assets were inspected. The only supplied logo-slot asset is three plain rectangles. Examples and tests use bracketed names/IDs; bibliography data is explicitly fictional. No official mark was downloaded. The original spec's sample ID remains in the specification, not in a document's personal-data fields. |
| 5. Notch only in the two prescribed places | PASS | Exactly two call sites: `src/titleblock.typ` and `src/cover.typ`; geometry is defined in `src/design.typ`. |
| 6. README requirements and compiling samples | PASS | Notice, three previews, logo instructions, both quick starts, complete argument tables, components, fonts and design notes. All nine Typst code samples compile in both modes. |
| 7. Source file limits and entrypoint | PASS | Every file under `src/` is below 300 lines (largest: 207). The script also enforces at most 100 characters per line in `lib.typ`, `src/`, `tests/`, `examples/`, and `template/`. `lib.typ` contains only explicit imports/re-exports. `tests/api.typ` asserts exactly 20 public names and their types, including the four-stack `monash-fonts` dictionary. |
| 8. Local Universe submission requirements | PASS | Manifest assertions, MIT license, named/versioned import, isolated fresh init, portable starter compile, PNG thumbnail from the initialized starter, longer edge 1169 px, under 3 MiB. Package bundle is in `build/unofficial-monash-report-0.1.0.tar.gz`. No remote submission or reviewer acceptance is claimed. |

## Precedence decisions and limitations

- The specification remains in `docs/spec/`; it is excluded from the package.
  All build products are under ignored `build/`, apart from the explicitly
  required README preview images and root thumbnail.
- Typst warns about missing names anywhere in a fallback list and has no
  in-document font-enumeration API. The specified preference lists remain
  in `src/design.typ`. The check script supplies its real font inventory;
  ordinary compilation without that inventory uses embedded fonts. The
  exported `monash-fonts` dictionary explicitly opts into all four complete
  preference lists with `report.with(..monash-fonts, title: [...])`. The README
  leads with this option and plainly states that Typst warns about any listed
  family that is not installed. The starter includes a commented opt-in line.
  Explicit font arguments are never filtered against the inventory.
- Section 4 takes precedence over CSS where sizes differ: for example,
  assignment title 22pt, body 11pt and footnote 9.5pt. Font-dependent line
  wrapping differs from the HTML renderer; previews are not bitmap-identical.
- Combined abstract/contents start at roman i, as required by section 4,
  although the mock says ii. The mock's contents puts section 2.2 on page 4,
  while its illustrated body places it on page 3. The generated contents
  correctly says 3. Report pages not provided by the mock use placeholders.
- The specification's fixed palette is retained. The README links the
  current Monash brand resources and explains that their palette differs;
  it does not falsely claim current brand-guideline compliance.
- The Universe thumbnail depicts the actual starter, rather than a report
  example, to satisfy the current thumbnail requirement.
- The sibling repository was read only. No code was copied from the
  unpublished fork named in the specification.
- Work is committed locally in conventional commits. No push, remote
  repository creation, pull request, tag or Universe publication was made.

## Review round 1 checks

All three commands above passed again with Typst 0.15.1. The thumbnail log is
`build/review-1-check-thumbnail.log`. Normal and embedded-only runs each
report 117 successes; the thumbnail run adds three successful PNG renders.

The line-limit checker counts UTF-8 characters, and the source-file checker
rejects 300 lines or more. Both run before document compilation. A temporary
102-character test line and a temporary 300-line source file each made
`scripts/check.sh` fail with the expected diagnostic; both probes were removed.
Probe command: `bash build/review-1-check-limits.sh`. Its diagnostic logs are
`build/review-1-line-limit.log` and `build/review-1-file-limit.log`.

Two direct font probes also passed:

```sh
TYPST_PACKAGE_PATH="$PWD/build/packages" typst compile --root . --ignore-system-fonts build/review-1-font-opt-in.typ build/review-1-font-opt-in.pdf
TYPST_PACKAGE_PATH="$PWD/build/packages" typst compile --root . build/review-1-font-auto.typ build/review-1-font-auto.pdf
```

The opt-in probe spreads `monash-fonts` into `report.with`, verifies the body
stack, and deliberately produces missing-family warnings with embedded fonts
only. The `auto` probe supplies no inventory, verifies Libertinus Serif, and
emits no diagnostics. These probes are separate from the warning-free checks.

The report cover/body previews and starter thumbnail are byte-for-byte
unchanged after reformatting. The assignment preview was refreshed after
removing the requested forced proof line break. The author metadata now reads
`["EY2234 <@Eryc123Y>"]`. All work remains local on the original branch.

## Review round 2 checks

The final three check commands pass with no warnings using Typst 0.15.1.
Normal and embedded-only runs each report 165 successes; the thumbnail run
reports 168, including its three PNG renders. The current thumbnail log is
`build/round-2-check-thumbnail.log`. The 100-character and below-300-line
source limits still pass; the largest source file remains 207 lines.

New observable-output assertions:

- `tests/omission.typ` is typeset for each field in each applicable mode.
  `scripts/assert-omission.pl` compares the complete printed-text records,
  page numbers, notch position and body positions with a clean baseline.
  The baselines are pinned by `tests/assets/omission-anchors.json`; unrequested
  wording or separators also fail. Each field must visibly change the output
  when set, so an ignored argument cannot produce a false pass.
- The fields are tutor, student ID, unit, semester, date, abstract, keywords,
  contents, supervisor, word count, subtitle, document type, faculty and marks.
  There are 19 applicable mode/field combinations. Both absent marks and
  `show-marks: false` must produce the same output and positions.
- `tests/labels.typ` checks all custom words, singular/plural labels, question,
  listing and seven theorem references, and group-author headings.
  `tests/empty-labels.typ` rejects leftover words, colons and proof full stops.
- `tests/question-options.typ` asserts numeric, string and content marks are
  suppressed together. It checks default English `1 mark` / `2 marks`, actual
  fill presence and the statement's left edge in both modes. Eight flag
  permutations run, and `scripts/assert-question-box.pl` checks both horizontal
  and vertical inset differences in four paired render comparisons.
- API failure cases cover unknown label keys, wrong label dictionary/value
  types, and non-boolean values for both new display flags in both modes.

Dates now default to `none` and contents to `false`, so leaving them unset
prints nothing. The report example and contents stress fixture explicitly
request contents. `README.md` has the output-choice table and all label keys;
`template/main.typ` marks every optional field as such. Section 3 of
`docs/spec/SPEC.md` records the new options and defaults. Native figure/table/
equation supplements and bibliography titles remain configurable with their
native arguments. No optional field is required by the starter.

All updated previews were rendered and inspected. No publication, push, PR
or tag was made.

The three existing README previews remain byte-for-byte identical with all
example fields explicitly enabled. The starter thumbnail changes only as
expected for the now-omitted automatic date.
