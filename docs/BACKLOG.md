# Backlog

Items found in the 0.2.0 review that were not changed. Bugs fixed in 0.2.0 are
listed in `CHANGELOG.md`.

## Design suggestions (not done)

- Enum labels alternate between `(a)` and `(i)`; a third nesting level repeats
  `(a)`. Consider a distinct third style.
- Bullet lists use the same square marker at every level. Consider a different
  marker per level.
- Table columns after the first are right-aligned, which suits numbers but not
  long text cells (now that they wrap). Consider left-aligning text columns or
  documenting `align:` overrides.
- Report chapters do not start on a new page.
- `monash-grey-dark` and `monash-grey` share one value, as do
  `monash-grey-soft` and `monash-grey-light`. Consider merging the names.
- The cover author table uses the table text size (10.5pt) under 12pt cover
  fields. Consider matching the field size.
- Level-1 headings with `outlined: false` get extra space below them
  (`contents-heading-extra`); revisit whether all such headings need it.

## Follow-ups to 0.2.0 fixes

- Tables: only fixed column widths (lengths and ratios) trigger scaling now.
  A table of `auto`/`fr` columns whose cells hold an unbreakable token wider
  than the text column overflows instead of shrinking.
- Cover: when the title block and author details cannot share the cover, the
  details flow after the title and may continue on a second cover-styled page.
  Shrinking a very long author table to fit might look better.
- Proofs: the end-of-proof square beside a numbered closing equation pushes
  that equation's number left by the square and a 6pt gap, so it no longer
  lines up with other equation numbers. The amsthm-style alternative (square
  before the number) needs the equation's own layout.
- Running heads: overlong text is truncated as plain text, so emphasis or
  maths in a long title or chapter heading is lost in the truncated head;
  content with no text at all is clipped. In a truncated chapter head the
  12pt gap after the chapter number also becomes a word space.
- Running heads: an outline's title is recognised as the first level-1 heading
  with `outlined: false` after the outline. An outline with `title: none`
  followed on its page by a user heading with `outlined: false` would hide that
  heading from the running head.
- README preview images link to the `v0.2.0` tag, which must exist (with the
  refreshed `docs/preview/*.png`) before the README is published.
