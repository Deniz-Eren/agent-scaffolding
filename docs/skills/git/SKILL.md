---
name: git
description: >
  Git conventions for this project. They include the commit identity,
  Conventional Commits messages, the Assisted-by footer, the commit modes, the
  git hooks (pre-commit and commit-msg), and the branch strategy. Use this skill
  when you install git hooks, make commits, or write commit messages. Use it
  also when you tag releases or manage branches.
---

# Git

## Commit mode

The mode is `operations.commit_mode` in `.agent-scaffolding.yml` at the project
root.

- **AUTONOMOUS:** Signature `--no-gpg-sign`. The agent commits and does not
  stop. Typical work: usual maintenance and document changes.
- **HITL:** The default signature. Print `WAITING FOR GPG SIGNATURE`, and wait
  for the human. Typical work: important changes, security work, and releases.

## Identity

Read the identity from `.agent-scaffolding.yml` (`identity.git_author_name`,
`identity.git_author_email`). The value `current_user` means the identity of the
current user. Take the name and the email from the git configuration of the
environment (`git config user.name`, `git config user.email`). Give it inline.
Do not run `git config` to change the identity:

```bash
git -c user.name="<name>" -c user.email="<email>" commit -F <message-file>
```

In AUTONOMOUS mode, add `--no-gpg-sign`.

## Message format

Obey [Conventional Commits](references/COMMITS.md):

```
<type>[(scope)][!]: <description>

[body]

Assisted-by: <AgentName>:<Model> [+ <Tool> ...]
```

- Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`,
  `ci`, `chore`, `revert`, `scaffold`.
- Breaking changes: put `!` after the type, or add a `BREAKING CHANGE:` footer.
- `Assisted-by:` is necessary for commits with help from AI. It gives the names
  of the agent and the model **of the current session**. Do not copy the footer
  from earlier commits.

Example:

```
feat(parser): support nested tables

Assisted-by: agent-name:model-name
```

## Git hooks

This repository uses tracked `pre-commit` and `commit-msg` hooks in
`scripts/hooks/`. Install them after you clone the repository, and before your
first commit:

```bash
scripts/install-git-hooks.sh
```

The installer links (or copies) each file in `scripts/hooks/` into the local git
hooks directory.

- **`scripts/hooks/pre-commit`:** Runs formatter checks (none configured here),
  script syntax and `shellcheck` checks, `scripts/verify.sh .`, and
  `agentskills validate` before each commit.
- **`scripts/hooks/commit-msg`:** Validates that the commit message obeys the
  rules of this skill. It checks the Conventional Commits header, the allowed
  types, and the empty line after the subject. It also checks uppercase
  `BREAKING CHANGE:` tokens and the `Assisted-by:` footer in the last trailer
  block. For commits with no AI help, set `ALLOW_NO_ASSISTED_BY=1`.

Do not use `--no-verify` to skip the git hooks. If a hook is not correct, repair
the problem and commit again.

## Workflow

1. Make sure that the git hooks are installed (`scripts/install-git-hooks.sh`).
2. Run `git status`, and stage only the files for this change.
3. Look at the staged diff with `git diff --staged`.
4. Complete the pre-commit checklist in [AGENTS.md](../../../AGENTS.md). For the
   state documents, see the [state-management
   skill](../state-management/SKILL.md).
5. Commit with the identity command above. The `pre-commit` and `commit-msg`
   hooks run automatically.
6. Do not push without clear approval from the human.

## Versions and releases

- Obey [Semantic Versioning](references/semver.md). The version is only in
  `metadata.version` in [SKILL.md](../../../SKILL.md).
  [CHANGELOG.md](../../../CHANGELOG.md) records each release.
- Tag releases as `vX.Y.Z`. Move the content of `## [Unreleased]` in
  [CHANGELOG.md](../../../CHANGELOG.md) into the new version section (see the
  [keepachangelog skill](../keepachangelog/SKILL.md)).

## Branches

- Branch protection is on for the default branch (`main`). Make your changes on
  feature branches that start from it.
- Squash-merge into the default branch. The squashed message obeys Conventional
  Commits.
