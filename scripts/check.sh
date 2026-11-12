#!/usr/bin/env bash
# Compile all documents through a temporary package path; every warning fails.
# Usage: scripts/check.sh [--ignore-system-fonts] [--thumbnail]
set -euo pipefail
cd "$(dirname "$0")/.."
font_flags=()
thumbnail=false
for arg in "$@"; do
  case "$arg" in
    --ignore-system-fonts) font_flags+=(--ignore-system-fonts) ;;
    --thumbnail) thumbnail=true ;;
    *) echo "unknown argument: $arg" >&2; exit 2 ;;
  esac
done
# Check every text file in the source trees, including SVG and YAML fixtures.
# Perl decodes UTF-8 so the width limit counts characters rather than bytes.
source_files=(lib.typ)
while IFS= read -r source; do source_files+=("$source"); done < <(
  find src tests examples template -type f | sort
)
if ! perl -CSD -ne '
  chomp;
  if (length($_) > 100) {
    printf "%s:%d: FAIL %d characters (maximum 100)\n", $ARGV, $., length($_);
    $invalid = 1;
  }
  if (eof) {
    if ($ARGV =~ m{^src/} && $. >= 300) {
      printf "%s: FAIL %d lines (must be fewer than 300)\n", $ARGV, $.;
      $invalid = 1;
    }
    close ARGV;
  }
  END { exit($invalid ? 1 : 0) }
' "${source_files[@]}"; then
  exit 1
fi
echo "ok    source limits: 100 characters per line; fewer than 300 lines per src file"

package_path="$(mktemp -d)"
trap 'rm -rf "$package_path"' EXIT
package_version="$(sed -n 's/^version = "\(.*\)"/\1/p' typst.toml)"
mkdir -p "$package_path/preview/unofficial-monash-report"
ln -s "$PWD" "$package_path/preview/unofficial-monash-report/$package_version"
export TYPST_PACKAGE_PATH="$package_path"
mkdir -p build
# Typst cannot enumerate fonts inside a document. Supply the actual font list,
# so unavailable fallback families are never passed to text(). No warning filters.
fonts="$(typst fonts ${font_flags[@]+"${font_flags[@]}"} | tr '\n' '|')"
failures=0
compile() {
  local input="$1" output="$2" log
  shift 2
  if ! log="$(typst compile --root . ${font_flags[@]+"${font_flags[@]}"} --input "monash-fonts=$fonts" "$@" "$input" "$output" 2>&1)"; then
    echo "FAIL  $input $*"
    echo "$log"
    failures=$((failures + 1))
  elif [[ -n "$log" ]]; then
    echo "FAIL  diagnostics from $input $*"
    echo "$log"
    failures=$((failures + 1))
  else
    echo "ok    $input $*"
  fi
}
while IFS= read -r file; do
  compile "$file" "build/${file//\//-}.pdf"
done < <(find tests examples template -type f -name '*.typ' | sort)
for field in subtitle unit doc-type author student-id supervisor date word-count faculty semester info authors; do
  compile tests/cover-fields.typ "build/cover-$field.pdf" --input "field=$field"
done
for file in no-logo logo stress numbering; do
  compile "tests/$file.typ" "build/$file-report.pdf" --input mode=report
done
# Exercise label overrides and both question flags in both document modes.
compile tests/empty-labels.typ build/empty-labels-report.pdf --input mode=report
compile tests/labels.typ build/labels-report.pdf --input mode=report
compile tests/labels.typ build/labels-group.pdf --input mode=report --input group=true
for mode in assignment report; do
  for hidden in false true; do
    for box in false true; do
      compile tests/question-options.typ "build/options-$mode-$hidden-$box.pdf" \
        --input "mode=$mode" --input "hidden=$hidden" --input "box=$box"
      metrics="build/options-$mode-$hidden-$box.json"
      diagnostics="build/options-diagnostics.log"
      if ! typst eval --root . ${font_flags[@]+"${font_flags[@]}"} \
        --input "monash-fonts=$fonts" --input "mode=$mode" --input "hidden=$hidden" \
        --input "box=$box" --in tests/question-options.typ \
        'query(metadata).find(it => type(it.value) == dictionary and
          "question-metrics" in it.value).value.question-metrics' \
        > "$metrics" 2> "$diagnostics"; then
        cat "$diagnostics"
        exit 1
      fi
      if [[ -s "$diagnostics" ]]; then cat "$diagnostics"; exit 1; fi
    done
    perl scripts/assert-question-box.pl "$mode" "$hidden" \
      "build/options-$mode-$hidden-false.json" "build/options-$mode-$hidden-true.json"
  done

done
# Compare actual typeset text and positions, with positive controls for every field.
snapshot_expression='
  query(metadata).filter(it => type(it.value) == dictionary and
    it.value.at("kind", default: none) in ("printed", "anchor", "shape"))
  .map(it => (kind: it.value.kind, text: it.value.text, page: it.location().page(),
    x: it.location().position().x.pt(), y: it.location().position().y.pt()))
'
mkdir -p build/omission
snapshot() {
  local mode="$1" field="$2" variant="$3" output="$4" log="build/omission/diagnostics.log"
  if ! typst eval --root . ${font_flags[@]+"${font_flags[@]}"} --in tests/omission.typ \
    --input "monash-fonts=$fonts" --input "mode=$mode" --input "field=$field" \
    --input "variant=$variant" "$snapshot_expression" > "$output" 2> "$log"; then
    cat "$log"
    return 1
  fi
  if [[ -s "$log" ]]; then cat "$log"; return 1; fi
}
for mode in assignment report; do
  fields=(student-id unit semester date marks)
  if [[ "$mode" == assignment ]]; then
    fields+=(tutor)
  else
    fields+=(abstract keywords outline supervisor word-count subtitle doc-type faculty)
  fi
  for baseline in common marks; do
    field=date
    [[ "$baseline" == marks ]] && field=marks
    snapshot "$mode" "$field" baseline "build/omission/$mode-$baseline.json"
  done
  for field in "${fields[@]}"; do
    baseline="build/omission/$mode-common.json"
    [[ "$field" == marks ]] && baseline="build/omission/$mode-marks.json"
    unset_path="build/omission/$mode-$field-unset.json"
    present_path="build/omission/$mode-$field-present.json"
    snapshot "$mode" "$field" unset "$unset_path"
    snapshot "$mode" "$field" present "$present_path"
    extra=()
    if [[ "$field" == marks ]]; then
      hidden_path="build/omission/$mode-marks-hidden.json"
      snapshot "$mode" "$field" hidden "$hidden_path"
      extra+=("$hidden_path")
    fi
    if ! perl scripts/assert-omission.pl "$mode" "$field" "$baseline" \
      "$unset_path" "$present_path" ${extra[@]+"${extra[@]}"}; then
      failures=$((failures + 1))
    fi
  done

done
# Negative cases are expected failures. Require a panic naming the bad argument.
negative() {
  local mode="$1" bad="$2" expected="$3" log
  if log="$(typst compile --root . ${font_flags[@]+"${font_flags[@]}"} --input "monash-fonts=$fonts" --input "mode=$mode" --input "bad=$bad" tests/api.typ build/invalid.pdf 2>&1)"; then
    echo "FAIL  $mode.$bad did not panic"
    failures=$((failures + 1))
  elif [[ "$log" == *"panicked with:"* && "$log" == *"\`$expected\`"* ]]; then
    echo "ok    rejects $mode.$bad"
  else
    echo "FAIL  $mode.$bad must panic naming $expected"
    echo "$log"
    failures=$((failures + 1))
  fi
}
for mode in assignment report; do
  for arg in title author student-id unit semester date short-title info logo font heading-font math-font code-font font-size accent paper lang; do
    negative "$mode" "$arg" "$arg"
  done
  for arg in labels show-marks question-box; do negative "$mode" "$arg" "$arg"; done
  negative "$mode" label-key labels.unexpected
  negative "$mode" label-value labels.question
  negative "$mode" unknown unknown-argument
  negative "$mode" missing-title title
  negative "$mode" relative-size font-size
  negative "$mode" bad-paper paper
  negative "$mode" info-item info
done
negative assignment tutor tutor
for arg in subtitle doc-type authors supervisor word-count faculty abstract keywords outline; do
  negative report "$arg" "$arg"
done
negative report author-key authors.extra
for arg in marks title number body unknown; do negative question "$arg" "$arg"; done
for kind in theorem lemma proposition corollary definition example remark proof; do negative "$kind" unknown unknown; done
negative appendix mode appendix
# README examples are standalone documents; the logo example gets a neutral asset.
if [[ -f README.md ]]; then
  rm -rf build/readme
  mkdir -p build/readme/assets
  cp tests/assets/placeholder.svg build/readme/assets/logo.svg
  awk '/^```typst$/ {n++; in_code=1; next} /^```$/ {in_code=0} in_code {print > ("build/readme/sample-" n ".typ")}' README.md
  for file in build/readme/sample-*.typ; do
    [[ -e "$file" ]] && compile "$file" "${file%.typ}.pdf"
  done
fi
# Copy only shippable files, so init cannot accidentally use excluded sources.
ship_dir="$package_path/isolated/preview/unofficial-monash-report/$package_version"
mkdir -p "$ship_dir"
cp typst.toml lib.typ LICENSE README.md CHANGELOG.md thumbnail.png "$ship_dir/"
cp -R src template "$ship_dir/"
export TYPST_PACKAGE_PATH="$package_path/isolated"
# Check that a completely fresh typst init works from the isolated bundle.
init_dir="build/fresh-init"
rm -rf "$init_dir"
if ! typst init "@preview/unofficial-monash-report:$package_version" "$init_dir"; then
  failures=$((failures + 1))
else
  compile "$init_dir/main.typ" build/fresh-init.pdf
fi
if [[ "$failures" -gt 0 ]]; then echo "$failures check(s) failed"; exit 1; fi
if [[ "$thumbnail" == true ]]; then
  mkdir -p build/preview docs/preview
  compile examples/assignment.typ 'build/preview/assignment-{p}.png' --ppi 96
  compile examples/report.typ 'build/preview/report-{p}.png' --ppi 96
  [[ "$failures" -eq 0 ]] || exit 1
  cp build/preview/assignment-1.png docs/preview/assignment.png
  cp build/preview/report-1.png docs/preview/report-cover.png
  cp build/preview/report-5.png docs/preview/report-body.png
  compile template/main.typ build/preview/thumbnail.png --pages 1 --ppi 100
  [[ "$failures" -eq 0 ]] || exit 1
  cp build/preview/thumbnail.png thumbnail.png
  echo "Regenerated thumbnail.png and docs/preview/*.png"
fi
# Local, reproducible package-shape checks (no network submission).
[[ "$(wc -c < thumbnail.png)" -le 3145728 ]] || { echo 'FAIL thumbnail size'; exit 1; }
read -r thumb_width thumb_height <<<"$(file thumbnail.png | sed -nE 's/.*PNG image data, ([0-9]+) x ([0-9]+).*/\1 \2/p')"
[[ "$thumb_width" -ge 1080 || "$thumb_height" -ge 1080 ]] || { echo 'FAIL thumbnail dimensions'; exit 1; }
if rg -n '^#[^i]|^[^#/[:space:]]' lib.typ; then echo 'FAIL lib.typ must only re-export imports'; exit 1; fi
cp thumbnail.png "$ship_dir/"
tar -czf "build/unofficial-monash-report-$package_version.tar.gz" -C "$ship_dir" .
echo "All checks passed ($(typst --version))"
