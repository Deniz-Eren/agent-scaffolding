# Conventions

## Purpose

Define the conventions of the agent-scaffolding project for file names, document
formatting, and copyright headers.

## Structure

The conventions are in groups by category: file names, document formatting,
document purposes, and copyright headers.

## Formatting Rules

- You must obey all conventions. A convention with the mark "recommended" is an
  alternative.
- Record each deviation as an ADR in [DECISIONS.md](DECISIONS.md).

---

## File Names

- **Scaffolding documents in `docs/`:** UPPERCASE. One word or a hyphenated
  name. Examples: `TASKS.md`, `THIRD-PARTY-NOTICES.md`.
- **Other documents:** A clear name. Example: `user-guide.md`.
- **Skills:** `docs/skills/<lowercase-name>/SKILL.md`. The directory name is the
  same as the frontmatter `name`. Example: `docs/skills/git/SKILL.md`.
- **Agent definitions:** `docs/agents/<lowercase-kebab>.md`. Example:
  `docs/agents/build.md`.
- **Skill references:** `references/<UPPERCASE>.md`. One file for each module in
  `references/modules/<kebab>.md`. Examples: `references/RULES.md`,
  `references/modules/dev-environment.md`.
- **Templates:** `assets/repo/` is a copy of the target path. Dotfiles do not
  have the dot at the start (`gitignore`, `agent-scaffolding.yml`). Example:
  `assets/repo/docs/TASKS.md`.
- **Scripts:** `scripts/<lowercase-kebab>.sh`, executable, with `#!/usr/bin/env
  bash`. Example: `scripts/verify.sh`.

## Document Formatting

- All markdown files that the skill makes in `docs/` (but not in `docs/skills/`
  or `docs/agents/`) start with these three headings, in this sequence:

  ```
  ## Purpose
  ## Structure
  ## Formatting Rules
  ```

- Do not put markdown links in backticks.
- Procedures are only in skill files. Other documents link to them.

## Document Purposes

| File | Contains | Must NOT contain |
|---|---|---|
| `ARCHITECTURE.md` | Current structure and components | Decisions or causes |
| `DECISIONS.md` | ADRs (dated, append-only) | The current structure |
| `TASKS.md` | Tasks with their status | General information |
| `CHANGELOG.md` (root) | Important changes by version | Current architecture |
| `VISION.md` | The mission and principles | Tasks |
| `CONVENTIONS.md` | Names, formatting, and copyright rules | Decisions |
| `THIRD-PARTY-NOTICES.md` | Third-party attribution | Internal architecture |

## Scripts

- All scripts start with the copyright line and `# SPDX-License-Identifier:
  MIT`.
- Scripts must report no findings from `shellcheck`. Disable a check only with a
  file-level directive that gives the cause.
- Scripts run on many systems. They do not use a GNU-only feature when POSIX has
  an alternative. They do not write absolute home paths.

## Templates

- Placeholders are `{{UPPER_SNAKE}}`. The skill defines each placeholder in
  [references/INTERVIEW.md](../references/INTERVIEW.md).
- Module blocks are `<!-- module:NAME -->` … `<!-- /module:NAME -->`, where NAME
  is a key in the `modules:` section of the config.
- In Markdown, do not put a placeholder in a code span (see [RULES.md
  §14](../references/RULES.md#14-templates-and-placeholders)).
