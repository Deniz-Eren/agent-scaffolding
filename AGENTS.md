# AI Agent Governance

This file has the highest authority for AI agents that work in
**agent-scaffolding**. The skill files in [docs/skills/](docs/skills/) have the
procedures with more information. This file links to them, and it does not give
the same information again.

---

## Commit Mode

`operations.commit_mode` in [.agent-scaffolding.yml](.agent-scaffolding.yml) is
the single source of truth for the commit mode and for the signature behavior of
the commits. Read the mode from there. The [git skill](docs/skills/git/SKILL.md)
defines the behavior of the modes and their typical work. This file does not
define the modes.

---

## Predict → Act → Verify

1. **Predict:** examine the task, plan the steps, and find the possible failures
   before you act.
2. **Act:** do the planned steps. Make an atomic commit after each phase.
3. **Verify:** run the checks (build, tests, format, lint), and confirm that
   they are correct.

If verification is not correct, go back to Act, repair the problem, and verify
again. Do not start the next phase until the current phase is correct.

---

## Failure Modes

- **The build is not correct:** Find the root cause. Repair the scaffolding (not
  the boilerplate). Run the build again. After three attempts with no success,
  stop, and get the approval of the human.
- **A test is not correct:** Find the source of the failure, and repair it. Then
  run the tests again. After three attempts with no success, stop, and get the
  approval of the human.
- **The formatter or the linter does not accept its config:** Remove one
  parameter at a time. Do a test again. Record an ADR. If the config is not
  correct after that, use a config with no parameters, and record the
  uncertainty.
- **A tool is not installed:** Write in the skill of the tool that the tool must
  be installed. Record an ADR.
- **A git conflict:** Stop the operation. Get the changes from the remote.
  Resolve the conflict. Attempt it again. If it continues, put the decision to
  the human.
- **The context or token limit is close:** Give a summary of the earlier
  context. Link to files. Do not copy their content.

---

## Boundaries for CLI Commands

| Command | Permitted | Approval necessary |
|---|---|---|
| Read files. Run `--version` checks. | ✓ | — |
| Run build, test, formatter, and hook scripts | ✓ | — |
| Commit | the commit mode in `.agent-scaffolding.yml` gives the rules | — |
| Install system packages | ✗ | ✓ |
| Erase project files | ✗ | ✓ |
| Change IMMUTABLE documents | ✗ | ✗ (not permitted) |
| Push to a remote | ✗ | ✓ |

---

## Token and Context Management

- Load a skill only when it is necessary for the task.
- Link to skill files and documents. Do not copy their content.
- Give a summary of the earlier context. Do not give it again.
- Read connected files in one batch.
- Write `~` or `$HOME`. Do not write an absolute home path.

---

## Git Protocol

Read the identity from `.agent-scaffolding.yml` (`identity.git_author_name`,
`identity.git_author_email`). The value `current_user` means the identity of the
current user. Take the name and the email from the git configuration of the
environment (`git config user.name`, `git config user.email`). Give the identity
inline for each commit. Do not change git config:

```bash
git -c user.name="<name>" -c user.email="<email>" commit -F <message-file>
```

Each commit message obeys Conventional Commits. It has an empty line and an
`Assisted-by:` footer at the end. The footer gives the names of the agent and
the model **of the current session**. Do not copy them from earlier commits:

```
<type>[scope]: <description>

Assisted-by: <AgentName>:<Model> [+ <Tool> ...]
```

Run `scripts/install-git-hooks.sh` one time on each repository instance to
install the `pre-commit` and `commit-msg` hooks. Check that the hooks are not
installed before you install them (`scripts/install-git-hooks.sh --check`). Do
not bypass the hooks with `--no-verify`. For the full procedure, see the
[git skill](docs/skills/git/SKILL.md).

---

## Pre-Commit Checklist

Before each commit, verify:

- [ ] The git hooks are installed (`scripts/install-git-hooks.sh`), and
  `pre-commit` and `commit-msg` are correct
- [ ] The commit message obeys Conventional Commits, and it has the
  `Assisted-by:` footer
- [ ] `shellcheck scripts/*.sh scripts/hooks/* assets/repo/scripts/*.sh
  assets/repo/scripts/hooks/*` reports no findings
- [ ] `agentskills validate` is correct for the skill (run it on a path with
  `agent-scaffolding` as the last component)
- [ ] `scripts/verify.sh .` reports no FAIL
- [ ] You updated `CHANGELOG.md` and `metadata.version` for changes to the
  behavior of the skill
- [ ] You updated `docs/TASKS.md` (`[x] COMPLETE YYYY-MM-DD`)
- [ ] `CHANGELOG.md` has an entry in `## [Unreleased]` for the change
- [ ] `docs/DECISIONS.md` has an ADR for each new decision
- [ ] `docs/THIRD-PARTY-NOTICES.md` has attribution for each new third-party
  component
- [ ] You did not change an IMMUTABLE document

For the update procedures, see the [state-management
skill](docs/skills/state-management/SKILL.md).

---

## Rules for This Project

This repository **is** the `agent-scaffolding` Agent Skill. The content of the
skill is [SKILL.md](SKILL.md), [references/](references/), [assets/](assets/),
and [scripts/](scripts/). This file and [docs/](docs/) govern the development of
the skill. The repository applies its own skill to itself (see
[.agent-scaffolding.yml](.agent-scaffolding.yml)).

- **IMMUTABLE:** [LICENSE.md](LICENSE.md) and the specifications in
  [references/specs/](references/specs/) with no changes. The copies in
  `docs/skills/*/references/` are symlinks to them.
- **Templates:** the files in [assets/repo/](assets/repo/) contain
  `{{PLACEHOLDERS}}` and module markers on purpose. When you change a template,
  also update the placeholder table in
  [references/INTERVIEW.md](references/INTERVIEW.md) and the checks in
  [scripts/verify.sh](scripts/verify.sh).
- **Spec notices:** when a spec in `references/specs/` changes, update its entry
  in [references/SPEC-NOTICES.md](references/SPEC-NOTICES.md) (copied into
  target projects) and in
  [docs/THIRD-PARTY-NOTICES.md](docs/THIRD-PARTY-NOTICES.md).
- **Releases:** for each change to the behavior of the skill, add an entry to
  [CHANGELOG.md](CHANGELOG.md), and increase `metadata.version` in `SKILL.md` as
  [SemVer](references/specs/semver.md) says.
- **Writing style:** use any currently installed Simplified Technical English
  skills for project documents; skip if none are installed. Only original
  project glossaries (`technical_terms.txt`, `allowed_phrases.txt`) stay here.
