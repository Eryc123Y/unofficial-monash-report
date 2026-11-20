# Changelog

## 0.2.0

- Centre list markers on the first line of each item.
- Hide the Student ID and Contribution columns of the author table when no
  author has a value for them.
- Bump every import, example, test and the starter template to 0.2.0; the
  check script now uses an empty package cache and fails on imports of any
  other version.
- Fix "cannot join label with content" for a labelled table outside a
  figure; the label stays queryable.
- Wrap long table cells at the text width. Only tables whose fixed column
  widths exceed the text width are scaled down.
- Accept a plain string as a `proof` body.
- Accept a plain string as `date`, as the README promised; document that
  `date: auto` prints today's date.
- Print dates without a leading zero ("1 November 2026").
- Let long code lines wrap inside the listing instead of overprinting its
  bottom rule and the text after it.
- Number figures, tables, listings, equations and theorems from the last
  numbered chapter. Unnumbered chapters no longer restart numbering or print
  a wrong prefix (such as 1.1 inside an appendix), and content before the
  first chapter is numbered 1, 2, ... instead of 0.1, 0.2, ...
- Restart custom figure kinds (such as `kind: "algo"`) in every chapter.
- Keep word spaces in the automatic short title and turn manual line breaks
  in the title into spaces.
- Number entries in a list of figures, tables or listings at the element,
  so they no longer all read "Figure 0.1".

## 0.1.0

- Initial assignment and report templates for Typst 0.15.
- Question statements, nested answer parts, shared theorem numbering and proofs.
- Report cover, group-author table, abstract, contents, appendices and running heads.
- Chapter-scoped figure, table, listing, equation and theorem numbering.
- Portable font selection, custom accent and optional user-supplied logo content.
- Local checks in both font modes, README sample compilation and CI.

### Review round 1

- Reformat source and fixtures to at most 100 characters per line; enforce
  that limit and fewer than 300 lines per source file in the check script.
- Build the syntax theme from a readable multi-line XML definition.
- Export `monash-fonts` for explicit use of all four preferred font stacks;
  document missing-font warnings and retain the existing `auto` defaults.
- Match the slides package's author metadata.
- Let the assignment proof paragraph flow without a forced line break.
- Refresh previews and verify all three check commands with Typst 0.15.1.

### Review round 2

- Add partial `labels` overrides for all package-owned wording and reference
  supplements; validate unknown keys and non-text values.
- Add `show-marks` and `question-box` controls in both modes, and use the
  singular mark label for numeric 1.
- Make dates and report contents opt-in when omitted; preserve the complete
  report example with an explicit contents option.
- Assert clean omission of 14 fields across 19 mode/field combinations using
  rendered text, shape positions, page counts and pinned body anchors.
- Assert custom/empty labels, references, mark visibility and horizontal and
  vertical statement insets in both modes.
- Document output choices, mark starter fields optional, and update section 3
  of the specification while retaining both source-size limits.
