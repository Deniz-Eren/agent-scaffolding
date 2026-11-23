#!/usr/bin/env bash
# {{COPYRIGHT_LINE}}
#
# Opens an interactive shell in the dev container. Builds the image first if needed.
set -euo pipefail
cd "$(dirname "$0")/.."

if command -v podman >/dev/null 2>&1; then
  exec podman compose run --rm dev "${@:-bash}"
elif command -v docker >/dev/null 2>&1; then
  exec docker compose run --rm dev "${@:-bash}"
else
  echo "error: neither podman nor docker is installed" >&2
  exit 127
fi
