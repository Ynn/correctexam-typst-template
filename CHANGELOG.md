# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- GitHub Actions CI/CD workflows for automated testing and releases
- Comprehensive CONTRIBUTING.md guide for contributors
- `.github/README.md` documenting workflow usage
- Enhanced `.gitignore` for Typst and Rust development

### Changed
- Improved documentation with detailed README sections

## [0.1.0] - 2024-01-XX

### Added

#### Typst Template Package
- Core template system with `correctexam()` show rule
- Question environments: `question-block()`, `question-inline()`
- Answer box system: `answer-box()`, `answer-lines()`, `answer-space()`
- QCM (multiple choice) support with `qcm-question()` and `option()`
- Page header with identity fields and corner markers
- Automatic zone marking system for machine grading
- Multi-language support (English, French) via `i18n` module
- Custom content boxes: `info-box()`, `warning-box()`, `note-box()`
- Attachment system for embedding grading data
- Comprehensive examples:
  - `exam-en.typ`: Full-featured English exam
  - `exam-fr.typ`: Full-featured French exam
  - `exam-anonymous.typ`: Anonymous exam template
- Quickstart templates for rapid project initialization
- Test suite with 7 test files covering edge cases
- 995-line README with:
  - Complete API reference (12 functions)
  - FAQ section (10 questions)
  - Best practices guide (9 subsections)
  - Troubleshooting section (11 common issues)

#### Rust Annotation Tool (`annotate-ce`)
- CLI tool for reading embedded marker metadata from Typst-compiled PDFs
- PDF annotation system writing CorrectExam data to PDF info dictionary
- Support for both native CLI and WASM compilation
- JSON marker format parsing and validation
- Error handling with detailed diagnostics
- Library interface (`libannotate_typst`) for programmatic use

### Fixed
- **Critical**: Fixed text overlapping identity fields on odd pages
  - Root cause: `header-ascent: 0%` eliminated buffer between header and body
  - Solution: Removed `header-ascent` override, used `place()` for corner markers
  - Verified: 5.9-8.9mm gap between identity fields and body content
- Consistent corner marker positioning across all pages
- Proper vertical alignment of page headers
- Removed deprecated `_apply-page-top-clearance()` system

### Technical Details

#### Layout System
- Default `header-ascent: 30%` provides buffer (~1.35cm at 4.5cm top margin)
- Corner markers positioned with `place(top + left, dx: 0cm, dy: 0.21cm)`
- Identity fields followed by `v(1.18cm)` vertical skip
- Body content starts at consistent y-position on all pages
- 4.5cm top margin accommodates: 2.5cm identity + 1cm markers + 1cm buffer

#### Build System
- Typst compiler 0.14.0 minimum requirement
- Rust edition 2021
- Cross-platform support: Linux, macOS, Windows
- PDF processing via `lopdf` 0.34
- Metadata serialization with `serde_json` 1.0

#### File Structure
```
correctexam-typst-template/
├── lib/
│   ├── lib.typ          # Main exports
│   ├── template.typ     # Page template
│   ├── header.typ       # Page headers
│   ├── questions.typ    # Question blocks
│   ├── qcm.typ          # Multiple choice
│   ├── markers.typ      # Zone marking
│   ├── utils.typ        # Utilities
│   ├── i18n.typ         # Translations
│   └── attach.typ       # PDF attachments
├── examples/            # Full-featured demos
├── quickstart/          # Minimal starters
└── tests/               # Test suite

annotate-typst/
├── src/
│   ├── main.rs          # CLI entry point
│   └── lib.rs           # Library interface
└── Cargo.toml           # Rust configuration
```

### Known Issues
- None currently

### Dependencies

#### Typst Package
- Typst compiler ≥ 0.14.0

#### Rust Tool
- Rust 2021 edition
- `lopdf` 0.34 - PDF manipulation
- `serde` 1.0 - Serialization framework
- `serde_json` 1.0 - JSON parsing
- `thiserror` 2.0 - Error types
- `anyhow` 1.0 - Error handling (CLI only)
- `clap` 4.5 - Command-line parsing (CLI only)
- `wasm-bindgen` 0.2 - WASM support (WASM only)

### Breaking Changes
- N/A (initial release)

### Migration Guide
- N/A (initial release)

---

## Version History

### Versioning Scheme

This project uses [Semantic Versioning](https://semver.org/):

- **MAJOR** version: Incompatible API changes
- **MINOR** version: New functionality (backward compatible)
- **PATCH** version: Bug fixes (backward compatible)

### Release Notes Format

Each version entry includes:

- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Vulnerability fixes

---

## Links

- [GitHub Repository](https://github.com/correctexam/correctexam-typst-template)
- [Issue Tracker](https://github.com/correctexam/correctexam-typst-template/issues)
- [Releases](https://github.com/correctexam/correctexam-typst-template/releases)
- [Typst Universe Package](https://typst.app/universe/package/correctexam)

---

**Note**: This changelog is maintained manually. For a complete list of changes, see the [commit history](https://github.com/correctexam/correctexam-typst-template/commits).
