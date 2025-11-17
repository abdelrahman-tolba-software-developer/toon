# Publishing Notes

## Dependency Versions

The build-time dependencies (`build`, `source_gen`, `analyzer`) are kept at compatible versions (^2.4.0, ^1.5.0, ^6.0.0) to ensure the code generator works correctly. These are build-time tools used by the `@ToonSerializable` annotation processor.

While newer versions exist, they have breaking changes that would require significant updates to the generator code. The current versions are:
- Stable and well-tested
- Compatible with each other
- Sufficient for the code generation functionality

## Pub.dev Score

The package may show a lower score for "All dependencies are latest" because:
- Build-time dependencies are intentionally kept at compatible versions
- These are internal implementation details, not public API
- Updating would require significant refactoring of the generator

The package is fully functional and production-ready with these dependency versions.

## Repository URL

The repository URL points to the specific package directory:
`https://github.com/abdelrahman-tolba-software-developer/toon/tree/main/packages/toon_formater`

This ensures pub.dev can correctly locate the package in the monorepo structure.
