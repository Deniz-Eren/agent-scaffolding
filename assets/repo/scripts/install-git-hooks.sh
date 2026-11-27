#!/usr/bin/env bash
# {{COPYRIGHT_LINE}}
#
# Installs the git hooks from scripts/hooks/ into the repository hooks directory.
# Command: scripts/install-git-hooks.sh
set -euo pipefail

cd "$(dirname "$0")/.."
ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "error: not inside a git repository" >&2
  exit 1
}
cd "$ROOT"

SRC_DIR="$ROOT/scripts/hooks"
if [ ! -d "$SRC_DIR" ]; then
  echo "error: hooks directory not found: $SRC_DIR" >&2
  exit 1
fi

HOOKS_DIR=$(git rev-parse --git-path hooks)
mkdir -p "$HOOKS_DIR"

installed=0
for hook in "$SRC_DIR"/*; do
  [ -f "$hook" ] || continue
  name=$(basename "$hook")
  dest="$HOOKS_DIR/$name"
  chmod +x "$hook"
  if [ "$HOOKS_DIR" = ".git/hooks" ] && ln -sfn "../../scripts/hooks/$name" "$dest" 2>/dev/null; then
    echo "installed (symlink): $dest -> ../../scripts/hooks/$name"
  else
    cp "$hook" "$dest"
    chmod +x "$dest"
    echo "installed (copy): $dest"
  fi
  installed=$((installed + 1))
done

if [ "$installed" -eq 0 ]; then
  echo "error: no hook files found in $SRC_DIR" >&2
  exit 1
fi

echo "HOOKS: installed $installed hook(s)"
