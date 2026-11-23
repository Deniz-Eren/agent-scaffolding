# Module: Build and Formatter Agents

This module makes scripts and subagent definitions, so that build, test, and
format work does not run in the context of the primary agent. This prevents a
context window full of build output. The configuration turns on this module with
`modules.build_agents`.

## Build Agent First

Make the build agent (and the formatter agent, if a formatter is configured)
**before** you write code or build the project. After that:

- If the platform has subagents, **delegate** all build, test, and format runs
  to these agents.
- If the platform has no subagents, run the scripts. Report only the summary
  line and the failures, not the full log.

## Scripts

- **`scripts/build-agent.sh`** (template:
  [build-agent.sh](../../assets/repo/scripts/build-agent.sh)): Build, tests, and
  lint.
- **`scripts/formatter-agent.sh`** (template:
  [formatter-agent.sh](../../assets/repo/scripts/formatter-agent.sh)):
  Formatting check **only**, no lint.

The two scripts must:

- Be executable and start with the copyright header (if the `copyright` module
  is on).
- Run the tools in the development environment. See
  [dev-environment.md](dev-environment.md).
- Look only at the source directories of the standard layout of the language
  (for example `src/`, `tests/`, and `include/` for C/C++, or `cmd/`, `pkg/`,
  and `internal/` for Go). Do not use other directory names.
- Do not look at `build/`, `.git/`, `node_modules/`, `__pycache__/`, `target/`,
  `vendor/`, `.venv/`, and other build or cache directories.
- Group the name conditions of `find` in parentheses: `find "$d" \( -name '*.c'
  -o -name '*.h' \) -print0`.
- Exit with 0 when the result is correct, and with a code that is not 0 after a
  build, test, lint, or format failure.
- `formatter-agent.sh` verifies by default. With `--fix`, it writes the files
  again.

## Agent definitions

Make `docs/agents/build.md` and `docs/agents/format-validator.md` from
[assets/repo/agents/](../../assets/repo/agents/). Each file has YAML frontmatter
with `name` and `description`, then a system prompt that links to the script and
to the skill for it. The `tools` field is not there on purpose, so that the
files work on all platforms. For the tool limits of each platform, see
[agent-platforms.md](agent-platforms.md).

## Skill

Add a `docs/skills/<build-system>/SKILL.md` (for example `cmake`, `poetry`, or
`npm`). It gives the commands to configure, build, test, and clean, the source
layout, and how `build-agent.sh` uses them. Add one skill for each linter or
formatter. Merge them into the skill of the build system when they share more
than 30 percent (see [RULES.md §11](../RULES.md#11-rules-for-skills)).
