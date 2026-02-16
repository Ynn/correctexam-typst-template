# CorrectExam Typst Tooling

This repository contains two components used together to generate and annotate CorrectExam-compatible PDFs.

## Components

### correctexam-typst-template/

Typst package used to write exams and embed marker metadata in the PDF.

Main topics are documented in [correctexam-typst-template/README.md](correctexam-typst-template/README.md).

### annotate-typst/

Rust CLI and library used to read embedded marker metadata and write `correctexam-*` entries into PDF metadata.

Main topics are documented in [annotate-typst/README.md](annotate-typst/README.md).

## Workflow

1. Write an exam with the Typst package.
2. Compile the exam to PDF with Typst.
3. Run `annotate-ce` on the generated PDF.
4. Use the annotated PDF in CorrectExam.

## Quick start

Prerequisites:

- Typst >= 0.14.0
- Rust stable toolchain

Compile an example and annotate it:

```bash
typst compile --root correctexam-typst-template \
  correctexam-typst-template/examples/exam-en.typ \
  correctexam-typst-template/build/exam-en.pdf

cargo run --manifest-path annotate-typst/Cargo.toml -- \
  correctexam-typst-template/build/exam-en.pdf \
  -o correctexam-typst-template/build/exam-en.annotated.pdf
```

## Documentation

- Package documentation: [correctexam-typst-template/README.md](correctexam-typst-template/README.md)
- Annotation tool documentation: [annotate-typst/README.md](annotate-typst/README.md)
- Contribution guide: [CONTRIBUTING.md](CONTRIBUTING.md)
- Changelog: [CHANGELOG.md](CHANGELOG.md)
- CI/CD workflows: [.github/README.md](.github/README.md)

## Development

Run Rust checks:

```bash
cd annotate-typst
cargo fmt --all -- --check
cargo clippy --all-targets --all-features -- -D warnings
cargo test
```

Run Typst checks:

```bash
cd correctexam-typst-template
./tests/validate.sh
```

## License

MIT. See [LICENSE](LICENSE).
