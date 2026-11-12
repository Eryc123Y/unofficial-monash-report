# Maintenance notes

## Author metadata

Use `EY2234 <@Eryc123Y>` in the `authors` field of `typst.toml` for every
release. The same name is used by the author's other Typst packages
(`scholia`, `unofficial-monash-touying`). The copyright holder in `LICENSE`
is `Eric Yang`.

## Logo

Never add a Monash logo, crest or wordmark to this repository, in any file or
image. Tests and previews use `tests/assets/placeholder.svg`.

## Requirements and design

`docs/spec/SPEC.md` is the requirements document and `docs/spec/design/` holds
the design mock. Run `scripts/check.sh` and
`scripts/check.sh --ignore-system-fonts` before every commit.
