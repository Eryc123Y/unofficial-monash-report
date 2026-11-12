# Changelog

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
