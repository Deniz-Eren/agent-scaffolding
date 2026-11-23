#!/usr/bin/env bash
# Copyright (c) 2026 Deniz Eren <deniz.eren@outlook.com>
# SPDX-License-Identifier: MIT
#
# Verifies a scaffolded project with the rules of the agent-scaffolding skill.
# Command: scripts/verify.sh [target-dir] [--with-build].
#   --with-build  Also runs scripts/build-agent.sh and scripts/formatter-agent.sh
#                 (delegate the runs to the build and format agents when possible)
# The exit code is 0 when no check gives FAIL. WARN results do not change the exit code.
# shellcheck disable=SC2015,SC2016  # ok/bad/wrn always give the exit code 0. Backticks in the regex are literal
set -uo pipefail

TARGET="."
WITH_BUILD=0
for a in "$@"; do
  case "$a" in
    --with-build) WITH_BUILD=1 ;;
    -h|--help) sed -n '2,10p' "$0"; exit 0 ;;
    *) TARGET="$a" ;;
  esac
done
cd "$TARGET" || { echo "error: cannot cd to $TARGET" >&2; exit 2; }

pass=0; warn=0; fail=0
ok()   { pass=$((pass + 1)); printf 'PASS  %s\n' "$1"; }
wrn()  { warn=$((warn + 1)); printf 'WARN  %s\n' "$1"; }
bad()  { fail=$((fail + 1)); printf 'FAIL  %s\n' "$1"; }
info() { printf 'INFO  %s\n' "$1"; }

# Prints the value of "key" in a top-level block of .agent-scaffolding.yml (example: cfg modules copyright).
cfg() {
  [ -f .agent-scaffolding.yml ] || return 0
  awk -v blk="$1" -v key="$2" '
    $0 ~ "^"blk":" {inblk=1; next}
    inblk && /^[^[:space:]#]/ {inblk=0}
    inblk && $1 == key":" {sub(/^[^:]*:[[:space:]]*/, ""); sub(/[[:space:]]*#.*/, ""); gsub(/"/, ""); print; exit}
  ' .agent-scaffolding.yml
}
enabled() { v=$(cfg modules "$1"); [ -n "$v" ] && [ "$v" != "false" ] && [ "$v" != "[]" ]; }
has_platform() { case " $(cfg modules agent_platforms | tr -d '[] ' | tr ',' ' ') " in *" $1 "*) return 0 ;; esac; return 1; }

# Removes fenced code blocks (also indented ones) from a markdown file.
strip_fences() { awk '/^[[:space:]]*(```|~~~)/ {f = !f; next} !f' "$1"; }

# Other paths to skip, from "exclude_paths: [a, b]" in .agent-scaffolding.yml.
EXCLUDES=()
if [ -f .agent-scaffolding.yml ]; then
  IFS=',' read -r -a EXCLUDES <<<"$(sed -n 's/^exclude_paths:[[:space:]]*\[\(.*\)\].*/\1/p' .agent-scaffolding.yml | tr -d ' "'"'"'')"
fi

# Text files to examine. The find command does not read .git, the specs with no changes, vendor directories, and exclude_paths.
gen_files() {
  local prune=(-path ./.git -o -path ./node_modules -o -path ./build -o -path ./target -o -path ./.venv -o -path ./venv -o -path ./vendor -o -path ./dist -o -path './docs/skills/*/references')
  local e
  for e in "${EXCLUDES[@]}"; do [ -n "$e" ] && prune+=(-o -path "./${e%/}"); done
  find . \( "${prune[@]}" \) -prune -o \
    -type f \( -name '*.md' -o -name '*.mdx' -o -name '*.sh' -o -name '*.yml' -o -name '*.yaml' -o -name '*.toml' -o -name '*.json' -o -name '*.cfg' -o -name '*.ini' \
      -o -name '*.py' -o -name '*.c' -o -name '*.h' -o -name '*.cc' -o -name '*.cpp' -o -name '*.hpp' -o -name '*.rs' -o -name '*.go' -o -name '*.js' -o -name '*.mjs' \
      -o -name '*.ts' -o -name '*.tsx' -o -name '*.jsx' -o -name '*.java' -o -name '*.kt' -o -name '*.cs' -o -name '*.rb' -o -name '*.cmake' -o -name 'CMakeLists.txt' \
      -o -name 'Makefile' -o -name 'Dockerfile' -o -name 'Containerfile' -o -name '.gitignore' -o -name '.python-version' \) -print 2>/dev/null
}
# Files that must have a copyright header when the copyright module is on.
header_files() {
  gen_files | grep -vE '\.(md|mdx|json)$|/\.gitignore$|/\.python-version$|^\./\.agent-scaffolding\.yml$'
}

# Removes code spans in lines (double-backtick spans first).
strip_code() { sed -E 's/``[^`]*``//g; s/`[^`]*`//g'; }

echo "# agent-scaffolding verify: $(pwd | sed "s#^$HOME#~#")"

# 1. Config
if [ -f .agent-scaffolding.yml ]; then ok ".agent-scaffolding.yml present"; else bad ".agent-scaffolding.yml missing"; fi

# 2. Doc headers
for f in CHANGELOG.md docs/TASKS.md docs/VISION.md docs/DECISIONS.md docs/CONVENTIONS.md docs/ARCHITECTURE.md docs/THIRD-PARTY-NOTICES.md; do
  if [ ! -f "$f" ]; then bad "$f missing"; continue; fi
  body=$(strip_fences "$f")
  p=$(grep -c '^## Purpose$' <<<"$body"); s=$(grep -c '^## Structure$' <<<"$body"); r=$(grep -c '^## Formatting Rules$' <<<"$body")
  order=$(grep -E '^## (Purpose|Structure|Formatting Rules)$' <<<"$body" | tr '\n' '|')
  if [ "$p$s$r" = "111" ] && [ "$order" = "## Purpose|## Structure|## Formatting Rules|" ]; then
    ok "$f headers"
  else
    bad "$f headers (Purpose=$p Structure=$s Formatting=$r, order: $order)"
  fi
done

# ADRs are newest first (git log order).
if [ -f docs/DECISIONS.md ]; then
  adrs=$(grep -oE '^## ADR-[0-9]+' docs/DECISIONS.md | grep -oE '[0-9]+' | tr '\n' ' ')
  [ "$adrs" = "$(printf '%s' "$adrs" | tr ' ' '\n' | sed '/^$/d' | sort -rn | tr '\n' ' ')" ] &&
    ok "DECISIONS.md ADRs are newest first" || bad "DECISIONS.md ADRs are not newest first"
fi

# 3. Root files
if [ -f README.md ]; then
  grep -qE '^## License[[:space:]]*$' README.md && ok "README.md has License section" || bad "README.md lacks '## License'"
  if enabled dev_environment; then
    grep -q '^## Development Environment' README.md && ok "README.md has Development Environment section" || bad "README.md lacks '## Development Environment'"
  fi
else
  bad "README.md missing"
fi
if [ -f AGENTS.md ]; then
  miss=""
  for s in 'Commit Mode' 'Predict' 'Failure Modes' 'Boundaries for CLI Commands' 'Token' 'Git Protocol' 'Pre-Commit Checklist'; do
    grep -qE "^##+ .*$s" AGENTS.md || miss="$miss '## $s'"
  done
  grep -q 'Assisted-by:' AGENTS.md || miss="$miss 'Assisted-by:'"
  [ -z "$miss" ] && ok "AGENTS.md has all required sections" || bad "AGENTS.md missing:$miss"
else
  bad "AGENTS.md missing"
fi

# 4. Template text that must not stay in generated files
residue=""
while IFS= read -r f; do
  case "$f" in *.md) content=$(strip_code <"$f") ;; *) content=$(cat "$f") ;; esac
  grep -qE '\{\{[A-Z_]+\}\}|<!-- */?module:' <<<"$content" && residue="$residue $f"
done < <(gen_files)
residue=${residue# }
[ -z "$residue" ] && ok "no template placeholders or module markers left" || bad "template text in: $residue"
todo=$(find scripts -name '*.sh' -print0 2>/dev/null | xargs -0 -r grep -lE '^[[:space:]]*(: )?# TODO:' 2>/dev/null)
[ -z "$todo" ] || wrn "TODO lines remain in: $(echo "$todo" | tr '\n' ' ')"
guide=""
for f in README.md AGENTS.md docs/*.md; do
  [ -f "$f" ] || continue
  strip_fences "$f" | strip_code | grep -E '<!--' | grep -qvE '<!-- *\[(CAT|DOC)\]' && guide="$guide $f"
done
[ -z "$guide" ] || wrn "template comments (<!-- ... -->) remain in:$guide"

# 5. Markdown checks: links in backticks, broken relative links, absolute home paths
bt=""; broken=""
while IFS= read -r f; do
  case "$f" in *.md) ;; *) continue ;; esac
  body=$(strip_fences "$f")
  dir=$(dirname "$f")
  # A link in backticks is an error only if its target is in the project. If the target is not in the project, it is a syntax example.
  while IFS= read -r t; do
    case "$t" in http://*|https://*) bt="$bt $f"; break ;; esac
    [ -n "$t" ] && [ -e "$dir/${t%%#*}" ] && { bt="$bt $f"; break; }
  done < <(grep -oE '`\[[^]]*\]\([^)]*\)`' <<<"$body" | sed -E 's/.*\]\(([^)]*)\)`$/\1/')
  while IFS= read -r link; do
    target=${link%%#*}
    [ -z "$target" ] && continue
    case "$target" in http://*|https://*|mailto:*|/*) continue ;; esac
    [ -e "$dir/$target" ] || broken="$broken $f->$target"
  done < <(strip_code <<<"$body" | grep -oE '\]\([^) ]+\)' | sed -E 's/^\]\(//; s/\)$//')
done < <(gen_files)
[ -z "$bt" ] && ok "no backtick-wrapped links" || bad "backtick-wrapped links in:$bt"
[ -z "$broken" ] && ok "relative links resolve" || bad "broken links:$broken"
home=$(gen_files | xargs -r grep -lE '/home/[a-z_][a-z0-9_-]*/|/Users/[A-Za-z]' 2>/dev/null)
[ -z "$home" ] && ok "no absolute home paths" || bad "absolute home paths in: $(echo "$home" | tr '\n' ' ')"

# 6. Skills
for s in create-skill git state-management keepachangelog; do
  [ -f "docs/skills/$s/SKILL.md" ] || bad "docs/skills/$s/SKILL.md missing"
done
if [ -f CHANGELOG.md ]; then
  grep -q "^## \[Unreleased\]" CHANGELOG.md && ok "CHANGELOG.md has [Unreleased] section" || bad "CHANGELOG.md has no ## [Unreleased] section"
else
  bad "CHANGELOG.md missing"
fi
for f in docs/skills/*/SKILL.md; do
  [ -f "$f" ] || continue
  dir=$(basename "$(dirname "$f")")
  fm=$(awk 'NR==1 && $0!="---" {exit} NR>1 && $0=="---" {exit} NR>1 {print}' "$f")
  name=$(sed -n 's/^name:[[:space:]]*//p' <<<"$fm" | head -1)
  desc=$(awk '/^description:/ {sub(/^description:[[:space:]]*/, ""); if ($0 ~ /^[>|][-+]?$/) {f=1; next} print; exit}
              f && /^[[:space:]]/ {sub(/^[[:space:]]+/, ""); printf "%s ", $0; next} f {exit}' <<<"$fm")
  lines=$(wc -l <"$f" | tr -d ' ')
  if [ "$name" != "$dir" ]; then bad "$f: name '$name' != directory '$dir'"
  elif ! grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$' <<<"$name" || [ ${#name} -gt 64 ]; then bad "$f: invalid name '$name'"
  elif [ -z "$desc" ] || [ ${#desc} -gt 1024 ]; then bad "$f: description empty or longer than 1024 characters"
  elif [ "$lines" -ge 500 ]; then wrn "$f: $lines lines (keep < 500)"
  else ok "$f"
  fi
done

# Standard agent link (core)
if [ -L .agents/skills ]; then
  [ -e .agents/skills ] && ok "symlink .agents/skills" || bad "broken symlink .agents/skills -> $(readlink .agents/skills)"
elif [ -d .agents/skills ]; then
  wrn ".agents/skills is a directory, not a symlink (keep the copies the same)"
else
  bad ".agents/skills missing (standard agent link: mkdir -p .agents && ln -sfn ../docs/skills .agents/skills)"
fi

# 7. Module files
if enabled dev_environment; then
  [ -f docs/skills/dev-environment/SKILL.md ] && ok "dev-environment skill" || bad "docs/skills/dev-environment/SKILL.md missing"
fi
if enabled build_agents; then
  need=(scripts/build-agent.sh docs/agents/build.md)
  [ "$(cfg operations formatter)" != "" ] && [ "$(cfg operations formatter)" != "none" ] && need+=(scripts/formatter-agent.sh docs/agents/format-validator.md)
  for x in "${need[@]}"; do
    if [ ! -e "$x" ]; then bad "$x missing"
    elif [[ "$x" == *.sh ]] && [ ! -x "$x" ]; then bad "$x not executable"
    else ok "$x present"
    fi
  done
fi
if enabled agent_platforms; then
  links=()
  has_platform claude && links+=(.claude/skills)
  if [ -d docs/agents ]; then
    has_platform claude && links+=(.claude/agents)
    has_platform copilot && links+=(.github/agents)
    has_platform pi && links+=(.pi/agents)
    has_platform opencode && links+=(.opencode/agents)
  fi
  for l in "${links[@]}"; do
    if [ -L "$l" ]; then [ -e "$l" ] && ok "symlink $l" || bad "broken symlink $l -> $(readlink "$l")"
    elif [ -d "$l" ]; then wrn "$l is a directory, not a symlink (keep the copies the same)"
    else bad "$l missing"
    fi
  done
  if has_platform claude; then
    grep -qx '@AGENTS.md' CLAUDE.md 2>/dev/null && ok "CLAUDE.md imports AGENTS.md" || bad "CLAUDE.md missing or does not contain '@AGENTS.md'"
  fi
fi
if enabled copyright; then
  nohdr=""
  while IFS= read -r f; do
    head -n 5 "$f" | grep -qi 'copyright' || nohdr="$nohdr $f"
  done < <(header_files)
  [ -z "$nohdr" ] && ok "copyright headers present" || bad "no copyright header in:$nohdr"
fi

# 8. Build and format
if [ "$WITH_BUILD" -eq 1 ]; then
  for sname in build-agent formatter-agent; do
    sc="scripts/$sname.sh"
    [ -x "$sc" ] || continue
    log=$(mktemp "${TMPDIR:-/tmp}/agent-scaffolding-$sname.XXXXXX")
    if "$sc" >"$log" 2>&1; then ok "run $sc"; rm -f "$log"; else bad "run $sc (log: $log)"; fi
  done
else
  info "build/format not run (delegate to the build agents, or use --with-build)"
fi

# 9. Git
if [ -d .git ]; then
  dirty=$(git status --porcelain | wc -l | tr -d ' ')
  [ "$dirty" = "0" ] && ok "git working tree clean" || wrn "git working tree has $dirty changes that are not committed"
  total=$(git rev-list --count HEAD 2>/dev/null || echo 0)
  info "commits: $total, with Assisted-by footer: $(git log --format='%B%x00' 2>/dev/null | tr '\0' '\n' | grep -c '^Assisted-by: ')"
  # Commits made since the skill was first applied must have the footer.
  first=$(git log --diff-filter=A --format=%H -- .agent-scaffolding.yml 2>/dev/null | tail -1)
  if [ -n "$first" ]; then
    nofoot=0
    for c in $(git rev-list "$first^!" "$first..HEAD" 2>/dev/null); do
      git log -1 --format=%B "$c" | grep -q '^Assisted-by: ' || nofoot=$((nofoot + 1))
    done
    [ "$nofoot" -eq 0 ] && ok "all commits since the skill was applied have an Assisted-by footer" || wrn "$nofoot commits since the skill was applied have no Assisted-by footer"
  fi
else
  bad "not a git repository"
fi

echo
echo "VERIFY: $pass passed, $warn warnings, $fail failed"
[ "$fail" -eq 0 ]
