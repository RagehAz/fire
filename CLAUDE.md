# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`fire` is a Flutter **library package** (not an app) providing a Firebase API layer (Firestore, Realtime Database, Storage, Auth) for the `bldrs` app and its sibling packages. It is never run standalone — there is no app to launch, only code consumed by dependents. It depends on the sibling package `basics` (see the `path:` dependency in `pubspec.yaml`), which supplies most of the domain models (`fire_helpers/models/...`) that this package's classes operate on.

## Architecture: single-library `part of` pattern

This package is one Dart **library**, not a collection of independent files. `lib/super_fire.dart` is the library root: it holds every `import`/`export`, and every other `.dart` file under `lib/` is pulled in via `part '...';` directives there. Each of those files starts with `part of super_fire;` and has no imports of its own.

When adding a new file:
- Start it with `part of super_fire;`, not its own `library`/`import` statements.
- Add a corresponding `part '...';` line in `lib/super_fire.dart` in the matching section (the file is organized into banner-commented sections: FOUNDATION, MODELS, HELPERS, WIDGETS, STREAMERS, PAGINATORS).
- Note several `part` lines for `b_models/` are commented out — those models actually live in the `basics` package instead and are imported, not defined here. Check `basics` before assuming a model type belongs in this repo.

Top-level `lib/` folders follow a lettered ordering convention (`a_foundation`, `b_models`, `c_helpers`, `d_widgets`, `e_streamers`, `f_paginators`, `g_builders`) indicating dependency/build order, not alphabetical naming.

## Code style

- Classes are `abstract class` with only `static` methods (no instances) — e.g. `OfficialAuthing`, `OfficialFire`. Follow this pattern for new API surfaces rather than introducing instantiable classes or providers.
- Relative imports are intentionally allowed (`always_use_package_imports: false` in `analysis_options.yaml`) "for easier file migration" — don't convert them to package imports.
- Errors are wrapped with shared helpers (`tryAndCatch`, `tryCatchAndReturnBool` from `basics`) rather than raw try/catch.
- Section dividers use `// ---` banner comments and `/// SECTION NAME` headers — match existing formatting when editing a file that uses them.
- Methods verified to work are marked `/// TESTED : WORKS PERFECT`; don't remove these markers when editing verified code.

## Verification

Run `flutter analyze` and `flutter test` before considering a change done. Test files must end in `_test.dart` (singular) or `flutter test` silently finds nothing — `test/fire_finder_tests.dart` was misnamed `_tests.dart` and never actually ran.

## Commit style

Recent commits are prefixed with the package version, e.g. `7.2 : UPDATED PACKAGES`, matching the `version:` field in `pubspec.yaml`. Bump the version in `pubspec.yaml` alongside meaningful changes and prefix the commit message with it.