// Locally checkable Universe manifest and template requirements.
#let manifest = toml("../typst.toml")
#assert.eq(manifest.package.name, "unofficial-monash-report")
#let version = manifest.package.version
#assert.eq(version, "0.2.0")
#assert.eq(manifest.package.authors, ("EY2234 <@Eryc123Y>",))
#assert.eq(manifest.package.compiler, "0.15.0")
#assert.eq(manifest.package.entrypoint, "lib.typ")
#assert.eq(manifest.package.license, "MIT")
#assert.eq(manifest.package.categories, ("report",))
#for folder in ("docs", "examples", "scripts", "tests", ".github", "build") {
  assert(folder in manifest.package.exclude, message: folder + " must be excluded")
}
#assert.eq(manifest.template.path, "template")
#assert.eq(manifest.template.entrypoint, "main.typ")
#assert.eq(manifest.template.thumbnail, "thumbnail.png")
#assert(read("../LICENSE").starts-with("MIT License"))
#let import-spec = "@preview/unofficial-monash-report:" + version
#assert(read("../template/main.typ").contains(import-spec))
#assert(read("../README.md").contains(import-spec))
Manifest and template metadata are valid.
