#!/usr/bin/env bash
# {{COPYRIGHT_LINE}}
#
# Formatter agent for {{PROJECT_NAME}}. It does a check of the formatting (no lint).
# Command: scripts/formatter-agent.sh [--fix]
# The exit code is 0 when the formatting is clean, and not 0 when there are violations.
set -euo pipefail
cd "$(dirname "$0")/.."

FIX=0
[ "${1:-}" = "--fix" ] && FIX=1

run() {
  # Native (Python):  (source .venv/bin/activate && "$@")
  # Containerized:    podman compose run --rm -T dev "$@"
  "$@"
}

# Source directories only. The script does not examine build/, .git/, node_modules/, __pycache__/, target/, vendor/, or .venv/.
SRC_DIRS=(src tests)
echo "==> format ($([ "$FIX" -eq 1 ] && echo fix || echo check)): ${SRC_DIRS[*]}"

if [ "$FIX" -eq 1 ]; then
  : # TODO: run ruff format "${SRC_DIRS[@]}"
    # TODO: run bash -c "find ${SRC_DIRS[*]} \\( -name '*.cpp' -o -name '*.hpp' \\) -print0 | xargs -0 -r clang-format -i"
else
  : # TODO: run ruff format --check "${SRC_DIRS[@]}"
    # TODO: run bash -c "find ${SRC_DIRS[*]} \\( -name '*.cpp' -o -name '*.hpp' \\) -print0 | xargs -0 -r clang-format --dry-run --Werror"
fi

echo "FORMAT: PASS"
