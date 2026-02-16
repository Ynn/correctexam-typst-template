# Contributing to CorrectExam Typst Template

Thank you for considering contributing to the CorrectExam Typst Template project! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Making Changes](#making-changes)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Release Process](#release-process)

## Code of Conduct

This project follows a code of conduct based on respect, inclusivity, and professionalism. Please be respectful in all interactions.

## Getting Started

### Prerequisites

- **Typst**: Version 0.14.0 or later ([install](https://github.com/typst/typst#installation))
- **Rust**: Latest stable version ([install](https://rustup.rs/))
- **Git**: For version control

### Clone the Repository

```bash
git clone https://github.com/correctexam/correctexam-typst-template.git
cd correctexam-typst-template
```

### Project Structure

```
correctexam-typst-template/
├── annotate-typst/           # Rust CLI tool for PDF annotation
│   ├── src/                  # Rust source code
│   └── Cargo.toml            # Rust dependencies
├── correctexam-typst-template/  # Typst package
│   ├── lib/                  # Template library code
│   ├── examples/             # Full-featured examples
│   ├── quickstart/           # Minimal starter templates
│   └── tests/                # Typst test files
└── .github/                  # CI/CD workflows
```

## Development Workflow

### Working with the Typst Template

1. **Make changes** to files in `correctexam-typst-template/lib/`

2. **Test your changes** by compiling examples:
   ```bash
   cd correctexam-typst-template
   typst compile --root . examples/exam-en.typ build/test.pdf
   ```

3. **Run all tests**:
   ```bash
   ./tests/validate.sh
   ```

### Working with the Rust Tool

1. **Make changes** to files in `annotate-typst/src/`

2. **Format code**:
   ```bash
   cd annotate-typst
   cargo fmt
   ```

3. **Check for linting issues**:
   ```bash
   cargo clippy --all-targets --all-features -- -D warnings
   ```

4. **Run tests**:
   ```bash
   cargo test
   ```

5. **Test the binary**:
   ```bash
   cargo run -- ../correctexam-typst-template/build/test.pdf -o output.pdf
   ```

## Making Changes

### Branching Strategy

- `main`: Stable release branch
- `develop`: Active development branch
- Feature branches: `feature/description` or `fix/description`

### Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks (dependencies, build config)

**Examples**:
```
feat(template): add support for custom answer box colors

fix(markers): correct alignment calculation for corner dots

docs(readme): add troubleshooting section for common errors

chore(deps): update lopdf to 0.35.0
```

### Code Style

#### Typst Code

- Use **2 spaces** for indentation
- Add comments for complex logic
- Follow naming conventions from existing code
- Keep functions focused and small

#### Rust Code

- Follow Rust standard style (`cargo fmt`)
- Add documentation comments (`///`) for public APIs
- Use meaningful variable names
- Prefer `?` operator for error handling

## Testing

### Automated Testing (CI)

All changes trigger automated tests via GitHub Actions:

1. Rust unit tests
2. Rust linting (clippy)
3. Rust formatting check
4. Typst compilation of all examples
5. Integration test (end-to-end workflow)

### Manual Testing

Before submitting a PR, verify:

1. **All examples compile**:
   ```bash
   cd correctexam-typst-template
   for f in examples/*.typ quickstart/*.typ tests/*.typ; do
     typst compile --root . "$f" "build/$(basename "$f" .typ).pdf"
   done
   ```

2. **Rust tests pass**:
   ```bash
   cd annotate-typst
   cargo test --all-features
   ```

3. **Visual inspection**: Open generated PDFs and verify:
   - Corner markers are positioned correctly
   - Identity fields don't overlap body text
   - Question zones and answer boxes render properly
   - QCM boxes align correctly

4. **Integration test**:
   ```bash
   # Compile + annotate
   typst compile --root correctexam-typst-template \
     correctexam-typst-template/examples/exam-en.typ \
     build/exam.pdf
   
   cargo run --manifest-path annotate-typst/Cargo.toml -- \
     build/exam.pdf -o build/exam.annotated.pdf
   
   # Verify annotations in PDF info
   pdfinfo build/exam.annotated.pdf | grep CorrectExam
   ```

### Adding Tests

#### Typst Tests

Create new test files in `correctexam-typst-template/tests/`:

```typst
// test-new-feature.typ
#import "/lib/lib.typ": correctexam

#show: correctexam.with(
  title: [Test New Feature],
  // ... configuration
)

// Test content here
```

#### Rust Tests

Add tests in `annotate-typst/src/` files:

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_new_feature() {
        // Test implementation
    }
}
```

## Submitting Changes

### Pull Request Process

1. **Fork the repository** (external contributors)

2. **Create a feature branch**:
   ```bash
   git checkout -b feature/my-awesome-feature develop
   ```

3. **Make your changes** and commit:
   ```bash
   git add -A
   git commit -m "feat(scope): add awesome feature"
   ```

4. **Push to your fork** (or origin for maintainers):
   ```bash
   git push origin feature/my-awesome-feature
   ```

5. **Create a Pull Request** on GitHub:
   - Base: `develop`
   - Compare: `feature/my-awesome-feature`
   - Fill in the PR template with details

6. **Address review feedback**:
   ```bash
   git add -A
   git commit -m "fix: address review comments"
   git push
   ```

### PR Requirements

- [ ] All CI checks pass
- [ ] Code follows style guidelines
- [ ] Tests added/updated for new features
- [ ] Documentation updated (README, comments)
- [ ] No merge conflicts with `develop`
- [ ] Commits follow conventional commit format

## Release Process

Releases are managed by maintainers. The process:

1. **Merge `develop` → `main`**:
   ```bash
   git checkout main
   git merge develop
   ```

2. **Update version numbers**:
   - `annotate-typst/Cargo.toml`
   - `correctexam-typst-template/typst.toml`
   - `CHANGELOG.md`

3. **Commit version bump**:
   ```bash
   git add -A
   git commit -m "chore: release version 0.2.0"
   git push origin main
   ```

4. **Create and push tag**:
   ```bash
   git tag -a v0.2.0 -m "Release version 0.2.0"
   git push origin v0.2.0
   ```

5. **GitHub Actions** will automatically:
   - Build binaries for all platforms
   - Package Typst template
   - Create GitHub Release with artifacts

6. **Publish to Typst Universe** (manual):
   ```bash
   cd correctexam-typst-template
   typst package upload
   ```

7. **Update `develop`** with version changes:
   ```bash
   git checkout develop
   git merge main
   git push
   ```

## Questions?

If you have questions or need help:

- Open a [GitHub Discussion](https://github.com/correctexam/correctexam-typst-template/discussions)
- Check existing [Issues](https://github.com/correctexam/correctexam-typst-template/issues)
- Read the [documentation](./correctexam-typst-template/README.md)

Thank you for contributing! 🎉
