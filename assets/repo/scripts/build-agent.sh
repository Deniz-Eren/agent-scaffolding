#!/usr/bin/env bash
# {{COPYRIGHT_LINE}}
#
# Build agent: build, test and static analysis for {{PROJECT_NAME}}.
# The exit code is 0 for PASS, and not 0 for FAIL.
# Fill in the TODO lines for the configured toolchain. Keep each step as one command.
set -euo pipefail
cd "$(dirname "$0")/.."

# Runs a command in the development environment. Keep one variant only.
run() {
  # Native (Python):  (source .venv/bin/activate && "$@")
  # Containerized:    podman compose run --rm -T dev "$@"
  # None:             "$@"
  "$@"
}

echo "==> build"
# TODO: run cmake -B build -S . && run cmake --build build
# TODO: run python -m pip install -e . --quiet

echo "==> test"
# TODO: run ctest --test-dir build --output-on-failure
# TODO: run pytest -q

echo "==> lint"
# Examine only the source directories. Group the find name clauses in parentheses.
# TODO: run ruff check src tests
# TODO: run bash -c "find src include tests \\( -name '*.cpp' -o -name '*.hpp' \\) -print0 | xargs -0 -r clang-tidy -p build"

echo "BUILD: PASS"
