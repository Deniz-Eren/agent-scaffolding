## Purpose

Keep a record of all the tasks of this project. Give the status and the date for
each task.

## Structure

Each task is a checkbox. The checkbox can have a date. Tasks are in groups by
category.

## Formatting Rules

- Use `[x]` for complete tasks. Use `[ ]` for the other tasks.
- Append ` YYYY-MM-DD` to complete tasks to record the date.
- Put tasks in groups with category headings.
- Put `[CAT]` at the start of category groups in comments. Then you can find the
  groups easily.

<!-- [DOC] 2026-06-06 scaffold: initial project structure -->

<!-- [CAT] Scaffolding -->

- [x] COMPLETE 2026-06-06 scaffold: make the initial project structure
- [x] COMPLETE 2026-06-06 scaffold: copy pre-existing documents
- [x] COMPLETE 2026-06-06 scaffold: add documentation framework
- [x] COMPLETE 2026-06-06 scaffold: make the skills directory
- [x] COMPLETE 2026-06-06 scaffold: finalize governance documents

<!-- [CAT] Development -->

- [x] COMPLETE 2026-06-06 docs: say clearly that the 6-project load test was
  manual, not a feature of the scaffolding
- [x] COMPLETE 2026-06-06 docs: repair the links in backticks and add ADR-7 to
  prevent the same error again
- [x] COMPLETE 2026-06-06 docs: repair ARCHITECTURE.md to give the current
  system architecture (not decisions), and update the bootstrap prompt
- [x] COMPLETE 2026-11-16 skill: change the bootstrap prompt into the
  llm-scaffolding Agent Skill (ADR-9)
- [x] COMPLETE 2026-11-16 skill: add the apply mode for existing projects, with
  audit and gap report
- [x] COMPLETE 2026-11-16 skill: add audit.sh and verify.sh, and validate the
  skill with agentskills and shellcheck
- [x] COMPLETE 2026-11-16 skill: apply the skill to this repository (ADR-12)
- [x] COMPLETE 2026-11-16 skill: validate the scaffolding with test runs
  (documentation project, Python project, existing repository) and repair the
  findings (ADR-14)
- [x] COMPLETE 2026-11-16 release: tag v0.1.0
- [x] COMPLETE 2026-11-17 docs: revise all documents in Simplified Technical
  English
- [x] COMPLETE 2026-11-17 skill: make the standard agent link `.agents/skills` a
  core item, and move the platform links into the target configuration (ADR-15)
- [x] COMPLETE 2026-11-17 skill: replace docs/HISTORY.md with CHANGELOG.md in
  the Keep a Changelog format, and add the keepachangelog core skill (ADR-16)
- [x] COMPLETE 2026-11-17 skill: make the git skill and AGENTS.md read the
  commit mode and the identity from the configuration (ADR-17)
- [x] COMPLETE 2026-11-17 skill: rename the project and the skill to
  agent-scaffolding (ADR-18)
- [x] COMPLETE 2026-11-19 skill: move the templates from assets/templates to
  assets/repo (ADR-19)
- [x] COMPLETE 2026-11-19 skill: make the identity configuration use the
  current_user tag (ADR-20)
- [x] COMPLETE 2026-11-19 docs: make CHANGELOG.md and DECISIONS.md newest first
  with the state-document headings (ADR-21)
- [x] COMPLETE 2026-11-19 skill: make AGENTS.md defer the commit mode to the
  configuration (ADR-22)
- [x] COMPLETE 2026-11-19 docs: rename docs/STANDARDS.md to docs/CONVENTIONS.md
  (ADR-23)
- [x] COMPLETE 2026-11-19 docs: put all entries of allowed_phrases.txt in one
  section and remove the category label
- [x] COMPLETE 2026-11-28 feat: enhance the git skill with pre-commit and
  commit-msg hooks and an installer script (ADR-24)
- [ ] Add documents for the development workflow
- [ ] Do a test of the skill with an agent platform

<!-- [CAT] Maintenance -->

- [ ] Look at the task list again at regular intervals, and change it
- [ ] Archive complete tasks each quarter
