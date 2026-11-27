#!/usr/bin/env bash
# Copyright (c) 2026 Deniz Eren <deniz.eren@outlook.com>
# SPDX-License-Identifier: MIT
#
# agent-scaffolding audit: read-only gap report for a target project.
# Command: scripts/audit.sh [target-dir]
# Output lines: <STATUS> <item>, where STATUS is OK, MISSING, CHECK or INFO.
# The script does not change the target. The exit code is always 0, with a target or without a target.
# shellcheck disable=SC2012  # ls of fixed, known filenames
set -uo pipefail

TARGET="${1:-.}"
[ -d "$TARGET" ] || { echo "error: '$TARGET' is not a directory" >&2; exit 2; }
cd "$TARGET" || exit 2

say() { printf '%-8s %s\n' "$1" "$2${3:+  — $3}"; }
have() { [ -e "$1" ]; }
check_file() { if have "$1"; then say OK "$1"; else say MISSING "$1" "${2:-}"; fi; }

# Prints "key: value" from a top-level block of .agent-scaffolding.yml (for example: cfg modules copyright), or nothing.
cfg() {
  [ -f .agent-scaffolding.yml ] || return 0
  awk -v blk="$1" -v key="$2" '
    $0 ~ "^"blk":" {inblk=1; next}
    inblk && /^[^[:space:]#]/ {inblk=0}
    inblk && $1 == key":" {sub(/^[^:]*:[[:space:]]*/, ""); sub(/[[:space:]]*#.*/, ""); gsub(/"/, ""); print; exit}
  ' .agent-scaffolding.yml
}
# The module is active when there is no config, or when the config turns it on.
enabled() { [ -f .agent-scaffolding.yml ] || return 0; v=$(cfg modules "$1"); [ -n "$v" ] && [ "$v" != "false" ] && [ "$v" != "[]" ]; }
# Agent platforms from the configuration. The default is an empty list.
platforms() { if [ -f .agent-scaffolding.yml ]; then cfg modules agent_platforms | tr -d '[] ' | tr ',' ' '; fi; }
has_platform() { case " $(platforms) " in *" $1 "*) return 0 ;; esac; return 1; }

PRUNE=(-path ./.git -o -path ./node_modules -o -path ./build -o -path ./target -o -path ./.venv -o -path ./venv -o -path ./vendor -o -path ./dist -o -path ./__pycache__)

echo "# agent-scaffolding audit of: $(pwd | sed "s#^$HOME#~#")"
echo

echo "## Detection"
if [ -d .git ]; then
  say INFO "git" "repository, $(git rev-list --count HEAD 2>/dev/null || echo 0) commits, $(git status --porcelain 2>/dev/null | wc -l | tr -d ' ') uncommitted changes"
else
  say INFO "git" "not a repository"
fi
files=$(find . \( "${PRUNE[@]}" \) -prune -o -type f -print 2>/dev/null | wc -l | tr -d ' ')
say INFO "files" "$files"
for m in package.json pyproject.toml requirements.txt setup.py Cargo.toml CMakeLists.txt Makefile go.mod build.gradle build.gradle.kts pom.xml; do
  have "$m" && say INFO "manifest" "$m"
done
exts=$(find . \( "${PRUNE[@]}" \) -prune -o -type f -name '*.*' -print 2>/dev/null \
  | sed 's/.*\.//' | grep -E '^(c|h|cc|cpp|hpp|cxx|py|rs|go|js|ts|tsx|jsx|java|kt|cs|swift|rb|sh)$' | sort | uniq -c | sort -rn | awk '{printf "%s(%s) ", $2, $1}')
say INFO "source extensions" "${exts:-none}"
for c in .clang-format .clang-tidy ruff.toml .ruff.toml .eslintrc .eslintrc.json eslint.config.js eslint.config.mjs .prettierrc .prettierrc.json rustfmt.toml .editorconfig; do
  have "$c" && say INFO "tool config" "$c"
done
lic=$(ls LICENSE* COPYING* 2>/dev/null | head -1)
if [ -n "$lic" ]; then
  lname=$(grep -m1 -oiE 'MIT License|Apache License|GNU (LESSER |AFFERO )?GENERAL PUBLIC LICENSE|BSD [0-9]-Clause|Mozilla Public License|The Unlicense|ISC License' "$lic" 2>/dev/null)
  say INFO "license" "$lic: ${lname:-unknown license}; $(grep -m1 -i 'copyright' "$lic" 2>/dev/null || echo 'no copyright line')"
fi
[ -f .agent-scaffolding.yml ] && say INFO "config" ".agent-scaffolding.yml skill_version=$(sed -n 's/^skill_version:[[:space:]]*"\{0,1\}\([^"]*\)"\{0,1\}.*/\1/p' .agent-scaffolding.yml)"
echo

echo "## Core"
if [ -d .git ]; then say OK ".git"; else say MISSING ".git" "git init"; fi
check_file .gitignore
check_file .agent-scaffolding.yml "written after interview"
if have README.md; then
  say OK README.md
  grep -q '^## License' README.md || say CHECK "README.md" "no '## License' section"
else
  say MISSING README.md
fi
if have AGENTS.md; then
  say OK AGENTS.md
  for s in 'Mode Selection' 'Predict' 'Failure Modes' 'Boundaries for CLI Commands' 'Token' 'Git Protocol' 'Pre-Commit Checklist' 'WAITING FOR GPG SIGNATURE' 'Assisted-by'; do
    grep -qi "$s" AGENTS.md || say CHECK "AGENTS.md" "missing: $s"
  done
else
  say MISSING AGENTS.md
fi
for f in CLAUDE.md GEMINI.md .github/copilot-instructions.md .cursorrules; do
  have "$f" || continue
  if [ "$f" = CLAUDE.md ] && [ "$(tr -d '[:space:]' <CLAUDE.md)" = "@AGENTS.md" ]; then say OK CLAUDE.md "imports AGENTS.md"; continue; fi
  say CHECK "$f" "existing instruction file; consolidate into AGENTS.md?"
done
for d in TASKS VISION DECISIONS CONVENTIONS ARCHITECTURE THIRD-PARTY-NOTICES; do
  check_file "docs/$d.md"
done
check_file CHANGELOG.md
for alt in docs/adr doc/adr docs/decisions CONTRIBUTING.md; do
  have "$alt" && say CHECK "$alt" "existing equivalent; link instead of duplicating?"
done
for s in create-skill git state-management keepachangelog; do
  check_file "docs/skills/$s/SKILL.md"
done
check_file docs/skills/git/references/COMMITS.md "spec"
check_file docs/skills/git/references/semver.md "spec"
check_file docs/skills/create-skill/references/SKILLS.mdx "spec"
if [ -d docs/skills ]; then
  for f in docs/skills/*/SKILL.md; do
    [ -f "$f" ] || continue
    dir=$(basename "$(dirname "$f")")
    name=$(sed -n '2,10s/^name:[[:space:]]*//p' "$f" | head -1)
    [ "$name" = "$dir" ] || say CHECK "$f" "frontmatter name '$name' != directory '$dir'"
  done
fi
if [ -L .agents/skills ]; then
  if [ -e .agents/skills ]; then say OK ".agents/skills" "-> $(readlink .agents/skills)"; else say CHECK ".agents/skills" "broken symlink -> $(readlink .agents/skills)"; fi
elif [ -d .agents/skills ]; then
  say CHECK ".agents/skills" "real directory; propose migrating into docs/skills and symlinking"
else
  say MISSING ".agents/skills" "standard agent link: mkdir -p .agents && ln -sfn ../docs/skills .agents/skills"
fi
check_file scripts/install-git-hooks.sh "installs git hooks from scripts/hooks/"
check_file scripts/hooks/pre-commit "runs formatter, test, and documentation checks"
check_file scripts/hooks/commit-msg "validates commit messages against the git skill"
if [ -d .git ]; then
  hooks_dir=$(git rev-parse --git-path hooks 2>/dev/null || echo .git/hooks)
  for h in pre-commit commit-msg; do
    if [ -x "$hooks_dir/$h" ]; then
      say OK "$hooks_dir/$h" "installed"
    elif [ -e "$hooks_dir/$h" ]; then
      say CHECK "$hooks_dir/$h" "present but not executable"
    else
      say INFO "$hooks_dir/$h" "not installed (run scripts/install-git-hooks.sh)"
    fi
  done
fi
echo

section() {
  if enabled "$1"; then echo "## Module: $1${2:-}"; return 0; fi
  echo "## Module: $1"; say SKIP "$1" "disabled in .agent-scaffolding.yml"; echo; return 1
}

if section dev_environment " [$(cfg operations dev_environment)]"; then
  if have docker-compose.yml || have compose.yaml || have compose.yml || have Dockerfile || have Containerfile; then
    say OK "containerized environment" "$(ls docker-compose.yml compose.yaml compose.yml Dockerfile Containerfile 2>/dev/null | tr '\n' ' ')"
    check_file scripts/enter-dev.sh
  elif have .python-version || have .venv || have .nvmrc || have rust-toolchain.toml; then
    say OK "native environment"
  else
    say MISSING "environment files"
  fi
  check_file docs/skills/dev-environment/SKILL.md
  if have README.md && ! grep -q '^## Development Environment' README.md; then say MISSING "README.md" "'## Development Environment' section"; fi
  echo
fi

if section build_agents; then
  check_file scripts/build-agent.sh
  check_file docs/agents/build.md
  check_file scripts/formatter-agent.sh "only if a formatter is configured"
  check_file docs/agents/format-validator.md "only if a formatter is configured"
  echo
fi

if section agent_platforms " [$(platforms)]"; then
  links=()
  has_platform claude && links+=(.claude/skills)
  if [ -d docs/agents ]; then
    has_platform claude && links+=(.claude/agents)
    has_platform copilot && links+=(.github/agents)
    has_platform pi && links+=(.pi/agents)
    has_platform opencode && links+=(.opencode/agents)
  else
    say INFO "agent links" "skipped: docs/agents/ does not exist"
  fi
  for l in "${links[@]}"; do
    if [ -L "$l" ]; then
      if [ -e "$l" ]; then say OK "$l" "-> $(readlink "$l")"; else say CHECK "$l" "broken symlink -> $(readlink "$l")"; fi
    elif [ -d "$l" ]; then
      say CHECK "$l" "real directory; propose migrating into docs/ and symlinking"
    else
      say MISSING "$l"
    fi
  done
  has_platform claude && ! have CLAUDE.md && say MISSING CLAUDE.md "one line: @AGENTS.md"
  echo
fi

# Source and config files that can have comments (used by the copyright and boilerplate checks).
source_files() {
  find . \( "${PRUNE[@]}" -o -path './docs/skills/*/references' \) -prune -o -type f \
    \( -name '*.c' -o -name '*.h' -o -name '*.cc' -o -name '*.cpp' -o -name '*.hpp' -o -name '*.cxx' -o -name '*.py' -o -name '*.rs' \
       -o -name '*.go' -o -name '*.js' -o -name '*.mjs' -o -name '*.ts' -o -name '*.tsx' -o -name '*.jsx' -o -name '*.java' -o -name '*.kt' \
       -o -name '*.cs' -o -name '*.swift' -o -name '*.rb' -o -name '*.sh' -o -path './scripts/hooks/*' -o -name '*.cmake' -o -name 'CMakeLists.txt' \
       -o -name '*.toml' -o -name '*.yml' -o -name '*.yaml' -o -name 'Dockerfile' -o -name 'Containerfile' -o -name 'Makefile' \) \
    ! -name '.agent-scaffolding.yml' -print0 2>/dev/null
}

if section copyright; then
  missing=0; total=0
  while IFS= read -r -d '' f; do
    total=$((total + 1))
    head -n 5 "$f" | grep -qi 'copyright' || { missing=$((missing + 1)); [ "$missing" -le 10 ] && say CHECK "$f" "no copyright header"; }
  done < <(source_files)
  [ "$missing" -gt 10 ] && say CHECK "..." "$((missing - 10)) more files without a header"
  say INFO "copyright headers" "$((total - missing))/$total files have a header"
  echo
fi

if section boilerplate; then
  ptype=$(cfg project type)
  nsrc=$(find . \( "${PRUNE[@]}" \) -prune -o -type f \( -path './src/*' -o -path './lib/*' -o -path './include/*' -o -path './tests/*' -o -path './test/*' \) -print 2>/dev/null | wc -l | tr -d ' ')
  if [ "$ptype" = documentation ]; then say INFO "boilerplate" "not applicable to documentation projects"
  elif [ "$nsrc" -gt 0 ]; then say OK "boilerplate" "$nsrc files in src/, lib/, include/ or tests/"
  else say MISSING "boilerplate" "no source or test files"
  fi
fi
