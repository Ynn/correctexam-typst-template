#!/usr/bin/env bash
set -euo pipefail

mkdir -p ../build

for test in test-*.typ; do
  name="${test%.typ}"
  out="../build/${name}.pdf"
  echo "=== ${name} ==="

  typst compile --root .. "$test" "$out"

  attachment_name="$(pdfdetach -list "$out" | awk -F': ' '/^[0-9]+: / {print $2; exit}')"
  if [[ -z "$attachment_name" ]]; then
    echo "missing attachment list entry in $out" >&2
    exit 1
  fi

  if [[ "$attachment_name" != "correctexam-markers.json" && "$attachment_name" != */correctexam-markers.json ]]; then
    echo "missing attachment in $out" >&2
    exit 1
  fi

  tmp_json="$(mktemp)"
  rm -f "$tmp_json"
  pdfdetach -savefile "$attachment_name" -o "$tmp_json" "$out" >/dev/null

  python3 - <<PY
import json

path = "${tmp_json}"
with open(path, "rb") as fh:
    markers = json.loads(fh.read())
if not markers:
    raise SystemExit("no markers found")

keys = [m["key"] for m in markers]
if len(keys) != len(set(keys)):
    raise SystemExit("duplicate keys found")

for m in markers:
    if m["w"] <= 0 or m["h"] <= 0:
        raise SystemExit(f"invalid dimensions: {m}")

print(f"OK - {len(markers)} markers")
PY

  rm -f "$tmp_json"

done
