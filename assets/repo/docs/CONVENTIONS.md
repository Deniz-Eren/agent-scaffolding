## Purpose

Define the conventions of {{PROJECT_NAME}} for file names, document formatting, and copyright headers.

## Structure

The conventions are in groups by category: file names, document formatting, document purposes, and copyright headers.

## Formatting Rules

- You must obey all conventions. A convention with the mark "recommended" is an alternative.
- Record each deviation as an ADR in [DECISIONS.md](DECISIONS.md).

---

## File Names

| Type | Rule | Examples |
|---|---|---|
| Scaffolding documents in `docs/` | UPPERCASE. One word or a hyphenated name. | `TASKS.md`, `THIRD-PARTY-NOTICES.md` |
| Other documents | A clear name | `user-guide.md` |
| Skills | `docs/skills/<lowercase-name>/SKILL.md`. The directory name is the same as the frontmatter `name` | `docs/skills/git/SKILL.md` |
| Agent definitions | `docs/agents/<lowercase-kebab>.md` | `docs/agents/build.md` |

## Document Formatting

- All generated markdown files in `docs/` (but not in `docs/skills/` or `docs/agents/`) start with these three headings, in this sequence:

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
| `ARCHITECTURE.md` | The current structure and components | Decisions or causes |
| `DECISIONS.md` | ADRs (dated, append-only) | The current structure |
| `TASKS.md` | Tasks with their status | General information |
| `CHANGELOG.md` (root) | The important changes, in groups by version | Descriptions of the current architecture |
| `VISION.md` | The mission and principles | Tasks |
| `CONVENTIONS.md` | Names, formatting, and copyright rules | Decisions |
| `THIRD-PARTY-NOTICES.md` | Third-party attribution | Internal architecture |

<!-- module:copyright -->
## Copyright Headers

License: **{{LICENSE_NAME}}**. Copyright line: {{COPYRIGHT_LINE}}

Each file with comments starts with the copyright line in the comment syntax of its language.

| Files | Header |
|---|---|
| <!-- one row for each file type in this project --> | |

**Exclusions:** markdown, `.gitignore`, license files, JSON, and immutable or append-only imported documents.
<!-- /module:copyright -->
