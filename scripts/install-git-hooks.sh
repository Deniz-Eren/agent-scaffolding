#!/usr/bin/env bash
# Copyright (c) 2026 Deniz Eren <deniz.eren@outlook.com>
# SPDX-License-Identifier: MIT
#
# Installs the git hooks from scripts/hooks/ into the repository hooks directory.
# Skips hooks that are already installed.
# Command: scripts/install-git-hooks.sh [--check]
#   --check  Verify whether all hooks are installed without modifying anything.
set -euo pipefail

CHECK_ONLY=0
case "${1:-}" in
  --check) CHECK_ONLY=1 ;;
  "") ;;
  -h|--help) sed -n '2,8p' "$0"; exit 0 ;;
  *) echo "error: unknown option: $1" >&2; exit 2 ;;
esac

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

is_installed() {
  local hook="$1"
  local name="$2"
  local dest="$3"
  if [ "$HOOKS_DIR" = ".git/hooks" ] && [ -L "$dest" ] && [ "$(readlink "$dest")" = "../../scripts/hooks/$name" ] && [ -x "$hook" ]; then
    return 0
  fi
  if [ -f "$dest" ] && [ -x "$dest" ] && cmp -s "$hook" "$dest"; then
    return 0
  fi
  return 1
}

found=0
installed=0
already=0
missing=0

for hook in "$SRC_DIR"/*; do
  [ -f "$hook" ] || continue
  found=$((found + 1))
  name=$(basename "$hook")
  dest="$HOOKS_DIR/$name"

  if is_installed "$hook" "$name" "$dest"; then
    echo "already installed: $dest"
    already=$((already + 1))
    continue
  fi

  if [ "$CHECK_ONLY" -eq 1 ]; then
    echo "not installed: $dest"
    missing=$((missing + 1))
    continue
  fi

  mkdir -p "$HOOKS_DIR"
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

if [ "$found" -eq 0 ]; then
  echo "error: no hook files found in $SRC_DIR" >&2
  exit 1
fi

if [ "$CHECK_ONLY" -eq 1 ]; then
  if [ "$missing" -gt 0 ]; then
    echo "HOOKS: $missing hook(s) not installed ($already already installed)"
    exit 1
  fi
  echo "HOOKS: all $already hook(s) installed"
  exit 0
fi

echo "HOOKS: $installed installed, $already already installed"
