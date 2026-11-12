# Local validation: 0.1.0

Validated with `typst 0.15.1 (unknown commit)` on `feat/initial-package`.

## Commands

Final checks (each exits 0 with no compiler errors or warnings):

```sh
scripts/check.sh
scripts/check.sh --ignore-system-fonts
scripts/check.sh --thumbnail
```

The first two logs are `build/check-system-fonts.log` and
`build/check-embedded-fonts.log`. Each run reports 116 successful checks,
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
| 3. Omitted optional arguments leave no gaps/separators | PASS | Title-only fixtures, `date: none`, empty fields, individual cover-field variants, no-logo fixtures, conditional row/column generation and filtered byline items. The byline's spacing is removed when no items remain. |
| 4. No Monash marks or personal details | PASS | All committed image assets were inspected. The only supplied logo-slot asset is three plain rectangles. Examples and tests use bracketed names/IDs; bibliography data is explicitly fictional. No official mark was downloaded. The original spec's sample ID remains in the untouched specification, not in a document's personal-data fields. |
| 5. Notch only in the two prescribed places | PASS | Exactly two call sites: `src/titleblock.typ` and `src/cover.typ`; geometry is defined in `src/design.typ`. |
| 6. README requirements and compiling samples | PASS | Notice, three previews, logo instructions, both quick starts, complete argument tables, components, fonts and design notes. All nine Typst code samples compile in both modes. |
| 7. Source file limits and entrypoint | PASS | Every `src/*.typ` is below 300 lines. `lib.typ` contains only explicit imports/re-exports. `tests/api.typ` asserts exactly 19 public names and their types. |
| 8. Local Universe submission requirements | PASS | Manifest assertions, MIT license, named/versioned import, isolated fresh init, portable starter compile, PNG thumbnail from the initialized starter, longer edge 1169 px, under 3 MiB. Package bundle is in `build/unofficial-monash-report-0.1.0.tar.gz`. No remote submission or reviewer acceptance is claimed. |

## Precedence decisions and limitations

- The specification remains in `docs/spec/`; it is excluded from the package.
  All build products are under ignored `build/`, apart from the explicitly
  required README preview images and root thumbnail.
- Typst warns about missing names anywhere in a fallback list and has no
  in-document font-enumeration API. The specified preference lists remain
  in `src/design.typ`. The check script supplies its real font inventory;
  ordinary compilation without that inventory uses embedded fonts. This is
  a deliberate portability adjustment, documented in the README. Explicit
  font overrides remain unchanged and can produce Typst warnings if missing.
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
