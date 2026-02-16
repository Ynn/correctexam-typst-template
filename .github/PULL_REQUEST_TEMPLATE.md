## Description

<!-- Provide a brief description of the changes in this PR -->

## Type of Change

<!-- Mark the relevant option with an "x" -->

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Code refactoring
- [ ] Performance improvement
- [ ] Test addition/update
- [ ] Build/CI configuration change

## Related Issues

<!-- Link to related issues, e.g., "Closes #123" or "Related to #456" -->

Closes #

## Changes Made

<!-- List the main changes made in this PR -->

- 
- 
- 

## Testing

<!-- Describe the tests you ran to verify your changes -->

### Checklist

- [ ] All Typst examples compile successfully
- [ ] Added tests for new functionality (if applicable)
- [ ] All existing tests pass
- [ ] Rust code passes `cargo clippy` without warnings
- [ ] Rust code is formatted with `cargo fmt`
- [ ] Visual inspection of generated PDFs (if applicable)
- [ ] Integration test passes (Typst + annotate-ce)

### Test Commands Run

```bash
# Typst compilation
cd correctexam-typst-template
typst compile --root . examples/exam-en.typ build/test.pdf

# Rust tests
cd annotate-typst
cargo test
cargo clippy --all-targets --all-features -- -D warnings
cargo fmt --all -- --check

# Integration test
# (describe your integration test here)
```

## Documentation

<!-- Mark if documentation was updated -->

- [ ] Updated README.md (if applicable)
- [ ] Updated CHANGELOG.md
- [ ] Added/updated code comments
- [ ] Updated API documentation (if applicable)

## Screenshots/Examples

<!-- If your changes affect the visual output, include before/after screenshots -->

### Before


### After


## Breaking Changes

<!-- If this is a breaking change, describe what breaks and how to migrate -->

N/A

## Additional Notes

<!-- Any additional information, context, or screenshots -->

## Reviewer Checklist

<!-- For maintainers reviewing this PR -->

- [ ] Code quality is acceptable
- [ ] Tests are adequate and pass
- [ ] Documentation is updated
- [ ] No security concerns
- [ ] Ready to merge
