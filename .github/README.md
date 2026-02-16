# GitHub Actions Workflows

This directory contains automated CI/CD workflows for the CorrectExam Typst Template project.

## Available Workflows

### 1. CI (`ci.yml`)

**Trigger**: Push or Pull Request to `main` or `develop` branches

**Purpose**: Continuous Integration testing for all code changes

**Jobs**:
- **test-rust**: Run Rust tests, linting (clippy), and formatting checks
- **test-typst**: Compile all Typst examples and tests to verify templates
- **integration-test**: End-to-end workflow test (Typst compile → annotate-ce)

**Artifacts**: Compiled PDF examples (retained for 7 days)

### 2. Release (`release.yml`)

**Trigger**: Push of version tags (e.g., `v0.1.0`) or manual dispatch

**Purpose**: Build and publish release artifacts

**Jobs**:
- **build-rust-binaries**: Cross-compile `annotate-ce` for 5 platforms:
  - Linux x86_64
  - Linux ARM64 (aarch64)
  - macOS Intel (x86_64)
  - macOS Apple Silicon (aarch64)
  - Windows x86_64
- **package-typst-template**: Create distributable Typst package archive
- **create-release**: Generate GitHub Release with all artifacts and release notes

**Artifacts**: Platform-specific binaries + Typst template tarball

## Making a Release

1. **Prepare the release**:
   ```bash
   # Update version in Cargo.toml and typst.toml
   vim annotate-typst/Cargo.toml
   vim correctexam-typst-template/typst.toml
   
   # Commit changes
   git add -A
   git commit -m "chore: bump version to 0.2.0"
   git push
   ```

2. **Create and push a tag**:
   ```bash
   git tag -a v0.2.0 -m "Release version 0.2.0"
   git push origin v0.2.0
   ```

3. **Wait for workflow**: The release workflow will automatically:
   - Build binaries for all platforms
   - Package the Typst template
   - Create a GitHub Release with all artifacts
   - Generate release notes

4. **Verify release**: Check the [Releases page](https://github.com/correctexam/correctexam-typst-template/releases)

## Local Testing

### Test CI Jobs Locally

```bash
# Test Rust formatting
cd annotate-typst && cargo fmt --all -- --check

# Test Rust linting
cd annotate-typst && cargo clippy --all-targets --all-features -- -D warnings

# Test Rust build and tests
cd annotate-typst && cargo test --verbose

# Test Typst compilation
cd correctexam-typst-template
for file in examples/*.typ tests/*.typ; do
  typst compile --root . "$file" "build/$(basename "$file" .typ).pdf"
done
```

### Test Integration Workflow

```bash
# Full end-to-end test
mkdir -p build

# Compile Typst
typst compile --root correctexam-typst-template \
  correctexam-typst-template/examples/exam-en.typ \
  build/exam-en.pdf

# Build and run annotate-ce
cargo build --release --manifest-path annotate-typst/Cargo.toml
./annotate-typst/target/release/annotate-ce \
  build/exam-en.pdf \
  -o build/exam-en.annotated.pdf
```

## Workflow Maintenance

### Updating Typst Version

Edit both workflow files to update the Typst version:

```yaml
- name: Install Typst
  uses: typst-community/setup-typst@v3
  with:
    typst-version: '0.14.0'  # Update this
```

### Adding New Build Targets

Edit `release.yml` to add new platforms to the build matrix:

```yaml
matrix:
  include:
    - os: ubuntu-latest
      target: <new-rust-target>
      artifact_name: annotate-ce
      asset_name: annotate-ce-<platform>-<arch>
```

### Cache Invalidation

If builds are failing due to corrupt cache:

1. Go to Actions → Select workflow → Caches
2. Delete problematic caches
3. Re-run the workflow

## Troubleshooting

### Release Workflow Fails

- **Binary build fails**: Check Rust target compatibility
- **Package creation fails**: Verify Typst compilation succeeds
- **Release creation fails**: Ensure `GITHUB_TOKEN` has `contents: write` permission

### CI Workflow Fails

- **Clippy errors**: Fix linting issues or update `.cargo/config.toml` to allow specific lints
- **Formatting errors**: Run `cargo fmt` and commit changes
- **Typst compilation fails**: Verify syntax in `.typ` files

### Cross-Compilation Issues (Linux ARM64)

The workflow installs `gcc-aarch64-linux-gnu` automatically. If cross-compilation fails:

```yaml
- name: Install cross-compilation tools (Linux ARM64)
  if: matrix.target == 'aarch64-unknown-linux-gnu'
  run: |
    sudo apt-get update
    sudo apt-get install -y gcc-aarch64-linux-gnu
```

Verify the linker configuration in `.cargo/config.toml` (if needed).

## Resources

- [GitHub Actions documentation](https://docs.github.com/en/actions)
- [Rust cross-compilation guide](https://rust-lang.github.io/rustup/cross-compilation.html)
- [Typst GitHub Actions setup](https://github.com/typst-community/setup-typst)
