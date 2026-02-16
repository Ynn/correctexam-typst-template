# annotate-typst

`annotate-typst` is the second step of the CorrectExam Typst pipeline.

It reads marker metadata from `correctexam-markers.json` (embedded by the Typst template) and writes `correctexam-*` entries into the PDF `Info` dictionary.

## Pipeline position

1. Generate exam PDF with `correctexam` Typst package.
2. Run `annotate-ce` on that PDF.
3. Use the resulting annotated PDF in CorrectExam.

## CLI usage

The binary name is `annotate-ce`.

```bash
cargo run -- exam.pdf
cargo run -- exam.pdf --output exam.annotated.pdf
```

If `--output` is omitted, output defaults to `input.annotated.pdf` in the same directory.

Example from workspace root:

```bash
typst compile --root correctexam-typst-template \
	correctexam-typst-template/examples/exam-en.typ \
	correctexam-typst-template/build/exam-en.pdf

cargo run --manifest-path annotate-typst/Cargo.toml -- \
	correctexam-typst-template/build/exam-en.pdf \
	-o correctexam-typst-template/build/exam-en.annotated.pdf
```

## Rust library API

Main functions:

- `annotate_pdf_bytes(pdf_bytes: &[u8]) -> Result<(Vec<u8>, AnnotationSummary), AnnotateError>`
- `extract_markers_from_pdf_bytes(pdf_bytes: &[u8]) -> Result<Vec<Value>, AnnotateError>`
- `parse_markers_json(markers_json: &str) -> Result<Vec<Value>, AnnotateError>`

## WASM build and API

Build:

```bash
cargo build --target wasm32-unknown-unknown --no-default-features --features wasm
```

Exported functions:

- `annotatePdf(pdfBytes: Uint8Array): Uint8Array`
- `extractMarkers(pdfBytes: Uint8Array): string`

## Error behavior

- Returns explicit error if `correctexam-markers.json` is missing.
- Returns explicit error if marker JSON is invalid or not an array.
- Clears previous `correctexam-*` metadata before writing new annotations.
