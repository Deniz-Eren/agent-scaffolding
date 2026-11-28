# Hard Rules

These rules apply to all projects that this skill scaffolds or updates, in
bootstrap mode and in apply mode. Module rules are in [modules/](modules/). Load
a module file only when its module is on.

## Contents

1. [Obey the configuration](#1-obey-the-configuration)
2. [Home paths](#2-home-paths)
3. [One source for each fact (DRY)](#3-one-source-for-each-fact-dry)
4. [AGENTS.md has the highest authority](#4-agentsmd-has-the-highest-authority)
5. [Git protocol](#5-git-protocol)
6. [Root files](#6-root-files)
7. [Document headers](#7-document-headers)
8. [Markdown links](#8-markdown-links)
9. [File names](#9-file-names)
10. [Document purposes](#10-document-purposes)
11. [Rules for skills](#11-rules-for-skills)
12. [Pre-existing documents](#12-pre-existing-documents)
13. [Build integrity](#13-build-integrity)
14. [Templates and placeholders](#14-templates-and-placeholders)
15. [Safety in existing projects](#15-safety-in-existing-projects)

---

## 1. Obey the configuration

Use the values in the `.agent-scaffolding.yml` of the target project (see
[INTERVIEW.md](INTERVIEW.md)). Obey `project.type`, `project.languages`,
`operations.*`, `operations.commit_mode`, and `modules.*` in all steps. Do not
generate content for a tool or a module that the configuration does not turn on.

## 2. Home paths

Write `~` or `$HOME` for paths in the home directory of the user. Do not write
an absolute `/home/<user>/...` path in generated files or commands. Such paths
can be incorrect, and they can have the name of a different user.

## 3. One source for each fact (DRY)

Instructions for operation (commands with more information, flags, sequences of
commands, and procedure steps) are **only** in the skill file for the subject in
`docs/skills/`. Other documents use relative links to that skill file.

| Element | README.md | AGENTS.md | ARCHITECTURE.md | Other `docs/*.md` |
|---|---|---|---|---|
| Single build and run commands | ✓ | ✗ | ✗ | ✗ |
| References to skill files (relative links) | ✓ | ✓ | ✓ | ✓ |
| Governance and CLI boundary tables | ✗ | ✓ | ✗ | ✗ |
| Failure modes table | ✗ | ✓ | ✗ | ✗ |
| Procedure summaries of one sentence | ✓ | ✓ | ✓ | ✗ |
| Command sequences with many steps | ✗ | ✗ | ✗ | ✗ |
| Explanations of commands, flag by flag | ✗ | ✗ | ✗ | ✗ |

- **Single command:** one command that you run one time, for example `cmake
  --build build`, `pytest`, or `cargo test`. `a && b` counts as two commands.
  Put it in a skill file.
- **Test:** if a reader can execute the procedure from the document without a
  skill file, move the procedure into a skill file. The commands section in
  README.md is the only document with commands.
- Generated skill files must not copy text with no changes from the references
  of this skill. Write instructions for the target project. The files in
  `assets/repo/` are different. The skill makes them for copies, and the agent
  changes them after the copy.

## 4. AGENTS.md has the highest authority

The skill generates the root `AGENTS.md` from
[assets/repo/AGENTS.md](../assets/repo/AGENTS.md). It must contain all these
sections:

- Commit mode from the configuration (`.agent-scaffolding.yml` is the single
  source of truth)
- Predict → Act → Verify workflow
- Failure modes table
- Boundaries for CLI commands
- Token and context management
- Git protocol (identity inline, `Assisted-by:` footer)
- Pre-commit checklist, with the maintenance of the documents that links to the
  `state-management` skill

If the project has `CLAUDE.md`, `GEMINI.md`, or
`.github/copilot-instructions.md`, do not copy their content a second time.
Propose to make `AGENTS.md` the source, and to make the other files one line
that points to `AGENTS.md`. Do this only with user approval.

## 5. Git protocol

- Each commit gives the identity inline: `git -c user.name="<name>" -c
  user.email="<email>" commit ...`. Do not change git config. Read the commit
  mode and the identity from the configuration of the project. The identity
  value `current_user` means the identity of the current user. Take the name and
  the email from the git configuration of the environment (`git config
  user.name`, `git config user.email`).
- The identity is the same in the two commit modes. The mode changes only:
  - **AUTONOMOUS:** continue with no stop, and add `--no-gpg-sign`.
  - **HITL:** stop before each commit, print `WAITING FOR GPG SIGNATURE`, and
    use the default signature.
- Commit messages obey Conventional Commits
  ([specs/COMMITS.md](specs/COMMITS.md)).
- Each commit message has an empty line at the end. Then comes an `Assisted-by:`
  footer with the names of the agent and the model **of the current session**:

  ```
  feat: add parser module

  Assisted-by: <agent-name>:<model> [+ <tool> ...]
  ```

  Do not keep one agent or model always in the project files. They change from
  session to session.
- Other trailers (for example `Co-authored-by:` or `Signed-off-by:`) go in the
  same trailer block as `Assisted-by:`, with no empty line between them.
- Make one atomic commit for each phase. Do not push without clear approval from
  the user.
- **Git hooks:** each target repository keeps tracked `pre-commit` and
  `commit-msg` hook scripts in `scripts/hooks/` and an executable installer
  script `scripts/install-git-hooks.sh` (templates in
  [assets/repo/scripts/](../assets/repo/scripts/)). Do not copy the hook
  templates with no changes. Specialize the two hooks to the target project and
  its other active skills:
  - `scripts/hooks/pre-commit` runs formatter checks, tests, and documentation
    checks across all project documents. Include rules from other active skills
    and project conventions (for example maximum line length, prose line
    packing, file headers, or documentation traceability checks).
  - `scripts/hooks/commit-msg` validates the commit message against the rules of
    the git skill. It checks the Conventional Commits header and types,
    empty-line separation, uppercase `BREAKING CHANGE:` tokens, and the
    `Assisted-by:` footer. Also specialize it to obey text rules from the
    project and other active skills (for example maximum line length, prose line
    packing in commit bodies, or traceability references).
  - `scripts/install-git-hooks.sh` checks whether each hook is installed before
    it installs missing hooks into the local git hooks directory. `AGENTS.md`
    tells agents to check that hooks are not installed before they run the
    installer one time on each repository instance. Do not bypass the hooks with
    `--no-verify`.

## 6. Root files

`README.md` must be at the project root. It contains:

- An overview of the project
- Commands for the start (single commands only), if the project has them
- A `## Development Environment` section, if the development environment module
  is on
- Relative links to `AGENTS.md`, `docs/ARCHITECTURE.md`, and the most important
  skills
- A `## License` section

The root also has the standard agent link. Make the symlink `.agents/skills` →
`docs/skills` after you make `docs/skills/`. Make a directory, a symlink, or an
instruction file for one platform only when `modules.agent_platforms` in the
configuration lists them. Examples are `.claude/`, `CLAUDE.md`, and
`.github/agents/` (see
[modules/agent-platforms.md](modules/agent-platforms.md)). The agent definitions
stay in `docs/agents/`, with no link at the root. If the project has platform
instruction files, propose to consolidate them into `AGENTS.md` (see §4), and do
this only with approval.

## 7. Document headers

All markdown files that the skill generates in `docs/` (but not in
`docs/skills/` or `docs/agents/`) start with these three headings, in this
sequence. An H1 title and a short introduction can come before them:

```
## Purpose
## Structure
## Formatting Rules
```

- This rule does not apply to IMMUTABLE documents and to the documents that the
  project had before. The skill copies them with no changes.
- Each heading is there one time only, at the top of the file. To document the
  header format itself, put it in a fenced code block.
- If a section in the body has one of these names, give it a different name. For
  example, use `## Mission` in VISION.md and `## Goals` in other files.
- [scripts/verify.sh](../scripts/verify.sh) checks these headings and does not
  look at fenced code blocks.

## 8. Markdown links

Do not put markdown link syntax in backticks. `` `[x](y)` `` shows as text, not
as a link. Use plain links: `[x](y)`. Backticks are only for code spans.

## 9. File names

- **Scaffolding documents in `docs/`:** UPPERCASE. One word or a hyphenated
  name. No space characters. Examples: `TASKS.md`, `THIRD-PARTY-NOTICES.md`.
- **Other documents in `docs/`:** No rule for capital letters and small letters.
  Example: `user-guide.md`.
- **Skills:** `docs/skills/<lowercase-name>/SKILL.md`. The directory name is the
  same as the frontmatter `name`. Example: `docs/skills/git/SKILL.md`.
- **Agent definitions:** `docs/agents/<lowercase-kebab>.md`. Example:
  `docs/agents/build.md`.
- **Root files:** The usual names. Examples: `README.md`, `AGENTS.md`,
  `LICENSE.md`.

**Project name conflicts:** sometimes the project name is the same as the name
of a library symbol in the target language. Examples: `json`, `uuid`, `yaml`,
`async`, `result`. Then add a suffix to the internal module name or namespace
name (for example `_core` or `_lib`). Keep the public project name with no
change, and record an ADR.

## 10. Document purposes

- **`docs/ARCHITECTURE.md`:** Contains the current architecture: system
  overview, directory structure, component descriptions, integration points.
  Must NOT contain decisions or causes.
- **`docs/DECISIONS.md`:** Contains ADRs (`Context`, `Decision`, `Alternatives`,
  `Consequences`), dated, append-only. Must NOT contain descriptions of the
  current architecture.
- **`docs/TASKS.md`:** Contains tasks. Complete tasks have the mark `[x]
  COMPLETE YYYY-MM-DD`. Must NOT contain general information.
- **`CHANGELOG.md` (root):** Contains the important changes, in groups by
  version. Must NOT contain descriptions of the current architecture.
- **`docs/VISION.md`:** Contains mission and guiding principles. Must NOT
  contain tasks.
- **`docs/CONVENTIONS.md`:** Contains file names, copyright headers, formatting
  rules. Must NOT contain decisions.
- **`docs/THIRD-PARTY-NOTICES.md`:** Contains attribution for copied files and
  dependencies. Must NOT contain internal architecture.

## 11. Rules for skills

- Make one skill for each different tool or task. Give each skill its own
  `docs/skills/<name>/SKILL.md`.
- The skill always makes these skills: `create-skill` (a skill for new skills),
  `state-management`, `git`, and `keepachangelog`.
- Make a skill for each configured tool. Do not make skills for tasks with no
  tool (for example `deploy` when no deployment tool is configured).
- If two skills share more than 30 percent of their instructions, merge them.
- Each skill obeys the Agent Skills specification
  ([specs/SKILLS.mdx](specs/SKILLS.mdx)): `name` (64 characters or fewer,
  lowercase letters, digits, and single hyphens), `description` (1024 characters
  or fewer. It tells what the skill does and when to use it), and a body of less
  than 500 lines. Put material with more information in `references/`.

## 12. Pre-existing documents

The configuration has these documents in `pre_existing_documents`. For each
entry:

1. Copy the source to the destination with no changes. Do not edit the source
   file.
2. If the copy is at a different directory depth, change the relative links in
   the copy so that they resolve after the move. Add `../` for each level
   deeper, or remove one `../` for each level that is nearer to the root.
3. Do not add a `## License` section or the three document headers to the copy.
4. Record the document in `CHANGELOG.md` in `## [Unreleased]`, category `###
   Added`, and put a reference to it in `docs/ARCHITECTURE.md`.
5. If the document comes from a third party, add an attribution entry to
   `docs/THIRD-PARTY-NOTICES.md`.
6. Obey the `policy` of the entry from then on:
   - `immutable`: do not change the document.
   - `append-only`: only add content to the document.
   - `editable`: change the document as usual.

The specification documents in [specs/](specs/) are pre-existing documents. For
their default destinations, see [BOOTSTRAP.md](BOOTSTRAP.md).

## 13. Build integrity

- You can build the project at all times. Do not commit while the build or the
  tests are not correct.
- If the build is not correct because of the scaffolding (for example an
  incorrect config or incorrect flags), repair the scaffolding, not the
  boilerplate.
- A tool config that the tool does not accept counts as a build failure.
- After three attempts to repair it with no success, change to HITL, and put
  your question to the user.
- If a configured tool is not installed, do not report that it was correct. Run
  it in an environment that you make only for the test (for example `python3 -m
  venv /tmp/x` or a container) if you can. If you cannot, give the result "not
  run", and record an ADR.

## 14. Templates and placeholders

The templates in [assets/repo/](../assets/repo/) use two markers:

- `{{PLACEHOLDER}}`: put the configured value there.
  [INTERVIEW.md](INTERVIEW.md#placeholders) defines all placeholders.
- `<!-- module:NAME -->` … `<!-- /module:NAME -->`: keep the content when module
  NAME is on, and always remove the markers. Remove the content also when the
  module is off.

No `{{` or `<!-- module:` markers can stay in the output. `scripts/verify.sh`
checks this. In Markdown, the check does not look at code spans, so documents
can show the marker syntax. Because of this, templates do not put a placeholder
in a code span. Change the template text to agree with the project. Templates
are a start. The agent changes them.

## 15. Safety with the files of the user

- Do not overwrite, erase, or rename a file without clear approval for that
  file.
- If the target file is there, **merge** the content: add the missing sections,
  and keep the content of the user.
- Do not commit changes of the user that have no connection to your work. If the
  working tree has changes before you start, stop, and put your question to the
  user.
- Do not run `git init` in a directory that is a repository.
