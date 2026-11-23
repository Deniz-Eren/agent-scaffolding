# Module: Boilerplate

This module makes a small code skeleton in the style of the language for a new
software project. The configuration turns on this module with
`modules.boilerplate`. Use it only in bootstrap mode, or in apply mode when the
project has no source files.

## Minimum structure

- One library build target with one or more exported functions or classes
- One executable build target that uses the library
- One or more tests with a correct result for each exported API surface
  (initialization, one core feature, and shutdown or cleanup)
- The executable answers `-h`/`--help` with help and version information

## Layouts in the style of each language

- **C/C++:** Public headers in `include/<name>/`, the code in `src/`, tests in
  `tests/`. Use a namespace. Make `include/` only when there is a public API.
- **Python:** `src/<package>/` with `__init__.py` exports, `tests/`,
  `pyproject.toml`.
- **JavaScript/TypeScript:** `src/` with barrel exports, ES modules, `tests/` or
  `*.test.ts`.
- **Rust:** `src/lib.rs` and `src/main.rs`, unit tests in the same files,
  integration tests in `tests/`.
- **Go:** `cmd/<name>/`, `internal/`, and `pkg/` only for public packages.

## Version: one source

The build configuration **alone** contains the project version (start at
`0.1.0`, as [../specs/semver.md](../specs/semver.md) says). The build system
gives the version to the code. Do not write the version again in source files or
in documents.

- **CMake:** Source `project(... VERSION x.y.z)`. `configure_file()` turns
  `<name>_config.h.in` into `<name>_config.h`. Use `@PROJECT_VERSION@`. Do not
  use `<name>_VERSION_STRING`, because CMake does not define it.
- **Cargo:** Source `[package] version`. Read with `env!("CARGO_PKG_VERSION")`.
- **npm:** Source `package.json` `version`. Read `package.json` at runtime, or
  generate a constant in a build step.
- **Python (PEP 621):** Source `pyproject.toml` `[project] version`. Read with
  `importlib.metadata.version("<dist>")`.
- **Go:** Source Git tag. Pass with `-ldflags "-X main.version=..."`.

## Verification

Delegate the build and the tests to the build agent
([build-agents.md](build-agents.md)). Do not make the commit until the build is
correct, all tests are correct, and the formatter check is clean.
