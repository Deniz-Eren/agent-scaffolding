# Apply Workflow (a project with files)

Use this workflow for a project that has files. Use it also to apply the skill
again after `.agent-scaffolding.yml` or the version of the skill changed. The
principle is **audit → propose → apply only what has approval**. Before you
start, read [RULES.md §15](RULES.md#15-safety-with-the-files-of-the-user).

`$SKILL` in this document is the directory of this skill.

## Phase 1: Preflight

1. Run `git status --porcelain`. If the working tree is dirty, stop. Put your
   question to the user: commit the changes or stash them first.
2. Propose a feature branch (for example `chore/agent-scaffolding`) as row 0 of
   the gap report in Phase 4. Make it before the first change, and only when the
   user agrees.
3. If `.agent-scaffolding.yml` is there, load it, and compare its
   `skill_version` with the `metadata.version` of this skill. If the versions
   are different, read [CHANGELOG.md](../CHANGELOG.md) for changes that are
   important for this skill.

## Phase 2: Interview

Run [INTERVIEW.md](INTERVIEW.md) in **apply** mode. The values that you find are
more important here: give a description of the tools that the project has, the
layout, and the conventions. Do not replace them. Example: if the project uses
`ruff`, do not propose `black`.

## Phase 3: Audit

1. Run `$SKILL/scripts/audit.sh <target>`. It gives `OK`, `MISSING`, or `CHECK`
   for each core item and each module item.
2. Look at the `CHECK` items one by one. For each file that is there, compare it
   with the rule and template for it:
   - **AGENTS.md:** which of the sections from [RULES.md
     §4](RULES.md#4-agentsmd-has-the-highest-authority) are missing?
   - **Platform instruction files** (for example `CLAUDE.md` or `.cursorrules`):
     is the content there two times? Propose to consolidate them into
     `AGENTS.md` ([RULES.md §4](RULES.md#4-agentsmd-has-the-highest-authority)).
   - **`docs/`:** are the names correct? Are the three headings there? Is
     ARCHITECTURE in a different document than DECISIONS?
   - **Skills:** do they obey the spec? Do the skills share parts?
   - **DRY:** are commands with many steps in files that are not skill files?
   - **Build and format:** are scripts or agents there? Is the build correct at
     this time?
   - **Git hooks:** are `scripts/install-git-hooks.sh`,
     `scripts/hooks/pre-commit`, and `scripts/hooks/commit-msg` there? Are other
     hooks in `.git/hooks/`? Propose to merge with hooks that are there, not to
     overwrite them without consent.
   - **Copyright:** give the source files that have no header.

## Phase 4: Gap report and plan

Show the user a table. Do not change a file before the approval:

| # | Item | Status | Step | Files | Risk |
|---|---|---|---|---|---|
| 0 | Branch | on default | make `chore/agent-scaffolding` | none | none |
| 1 | AGENTS.md | missing sections | merge from template | `AGENTS.md` | low |
| 2 | docs/DECISIONS.md | missing | make from template | new file | none |
| … | | | | | |

- Use these verbs: **make** (a new file), **merge** (add to a file that is
  there), **replace** (clear consent is necessary), **link** (a symlink), and
  **skip**.
- Group the items by core and by module, so that the user can accept them in
  groups.
- Put your question to the user: which items to apply. Use the question tool of
  the platform if the platform has one. Record the decision in
  `.agent-scaffolding.yml` (for example, set a module that is off to `false`).

## Phase 5: Apply

Apply **only the items with user approval**. Use the same phase sequence as in
[BOOTSTRAP.md](BOOTSTRAP.md), and skip `git init` and the steps that the project
has. Rules for this phase:

- **Merge, do not overwrite:** keep the content of the user. Add the missing
  sections next to the sections that are there. Keep the words of the user when
  they mean the same.
- **AGENTS.md:** start from the template. Move the rules of the user that the
  template does not include into the `## Rules for This Project` section. Do not
  drop a rule.
- **`.gitignore`:** append only the template lines that are missing, below a `#
  agent-scaffolding` comment. Do not remove lines that are there, and do not
  change their sequence. Do not ignore a path that is in git.
- **Task and decision data that is there:** if the project records tasks,
  decisions, or changes in a different location (for example `CHANGELOG.md`,
  `adr/`, or GitHub Issues), propose a link to it. Do not make a second copy.
- **Tool configs that are there:** keep them. Only verify them
  ([modules/tool-configs.md](modules/tool-configs.md)), and give the problems.
- **Code:** do not run the boilerplate module when the project has source files.
  Do not format all the code again without clear approval. A new format makes a
  very large diff.
- Record an ADR for each important adoption or deviation, for example "kept the
  CHANGELOG.md that was there, with no new sections for the scaffold".
- Make one atomic commit for each group of items that you applied.

## Phase 6: Verify and report

1. Run `$SKILL/scripts/verify.sh <target>` ([VERIFICATION.md](VERIFICATION.md)).
   If the build module is on, delegate the build and the format check.
2. Update `skill_version` in `.agent-scaffolding.yml`, and mark the tasks
   complete. Complete the scaffolding entry in `CHANGELOG.md` in `##
   [Unreleased]`, or add one.
3. Give a report:
   - What you applied, what you skipped, and what waits for a decision
   - The output of `verify.sh`
   - The open items that wait for a decision from a human
