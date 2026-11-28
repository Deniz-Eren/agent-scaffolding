## Purpose

Record the important changes of the agent-scaffolding Agent Skill. The format
follows [Keep a Changelog](https://keepachangelog.com). The users of the skill
read this file when they upgrade a project in apply mode.

## Structure

- The `## [Unreleased]` section is at the top. Below it, the releases are newest
  first (git log order).
- Category headings of level 3 in each section: `### Added`, `### Changed`, `###
  Deprecated`, `### Removed`, `### Fixed`, and `### Security`. Put a heading
  into the file only when the section has content for it.

## Formatting Rules

- Release heading: `## [x.y.z] - YYYY-MM-DD`.
- The entries in each category are newest first (git log order).
- Write each entry as a complete sentence with a final period.

## [Unreleased]

### Added

- Check-before-install behavior (`--check` and skip when installed) in
  `scripts/install-git-hooks.sh` and one-time install instructions in `AGENTS.md`
  (ADR-25). Agents must also specialize `pre-commit` across all documents and
  `commit-msg` for rules from other active skills.
- Core git hooks (`scripts/hooks/pre-commit` and `scripts/hooks/commit-msg`)
  and an installer script (`scripts/install-git-hooks.sh`) in `assets/repo/` and
  this repository (ADR-24). Updated the `git` skill, `RULES.md`, `BOOTSTRAP.md`,
  `APPLY.md`, `VERIFICATION.md`, `scripts/audit.sh`, and `scripts/verify.sh` for
  the hooks.

### Changed

- `assets/repo/docs/THIRD-PARTY-NOTICES.md`, `docs/THIRD-PARTY-NOTICES.md`,
  `references/SPEC-NOTICES.md`, the `state-management` skill, `RULES.md`, and
  `BOOTSTRAP.md` use short license summaries with no full license text blocks
  (ADR-26).
- `docs/STANDARDS.md` has the new name `docs/CONVENTIONS.md` (ADR-23).
- `AGENTS.md` does not define the commit modes and the signature flag. The
  configuration (`operations.commit_mode`) and the git skill give them (ADR-22).
- `CHANGELOG.md` and `docs/DECISIONS.md` are newest first (git log order), and
  they start with the sections `Purpose`, `Structure`, and `Formatting Rules`
  (ADR-21).
- `identity.git_author_name` and `identity.git_author_email` accept the value
  `current_user`. The agents take the name and the email from the git
  configuration of the current user (ADR-20).
- The templates moved from `assets/templates/` to `assets/repo/`. The directory
  tree below `assets/repo/` matches the target repository (ADR-19).

## [0.1.0] - 2026-11-17

### Added

- Three end-to-end test runs validated the skill (a documentation project, a
  Python project, and an existing repository).
- Attribution entries for the specifications in the skill
  (`references/SPEC-NOTICES.md`). Agents copy them into the target project.
- `CHANGELOG.md` at the project root, in the Keep a Changelog format (see the
  keepachangelog skill).
- The core skills: `create-skill`, `git`, `state-management`, and
  `keepachangelog`.
- Optional links for agent platforms that do not read `.agents/skills` (the
  `agent_platforms` module).
- The standard `.agents/skills` symlink to `docs/skills`, so that agent
  platforms find the project skills.
- `scripts/audit.sh` (a read-only gap report) and `scripts/verify.sh` (a check
  of the target against the rules).
- Templates for all the files that the skill makes (`assets/templates/`).
- Core rules (`references/RULES.md`) and optional modules: `dev_environment`,
  `build_agents`, `tool_configs`, `boilerplate`, `copyright`, and
  `agent_platforms`.
- The interview workflow. It finds many values automatically, and it keeps the
  answers in the `.agent-scaffolding.yml` file between runs.
- The `agent-scaffolding` Agent Skill (`SKILL.md`) with two modes: **bootstrap**
  (a new project) and **apply** (an existing project: audit, gap report, and
  only the changes with user approval).

### Changed

- This release replaces the earlier bootstrap prompt. The rules stay, with these
  differences:
  - The skill also links the project skills, so that agents can find them
    (`.agents/skills`).
  - The `Assisted-by:` footer always gives the agent and the model of the
    current session, not values from the config.
  - The agent definitions do not have `tools`, so you can use the same files on
    all platforms.
  - The rules of the prompt are in `references/RULES.md`: home paths, the build
    agent before build work, and the separation of ARCHITECTURE.md and
    DECISIONS.md. The rule for markdown links stays: no links in backticks.
  - The claim of an automatic 6-project load test is gone. The load test was a
    manual step.
- The project has the new name `agent-scaffolding`. The earlier name was
  `llm-scaffolding` (ADR-18).
- The git skill and `AGENTS.md` read the commit mode and the identity from
  `.agent-scaffolding.yml` (ADR-17). The configuration is the one source of
  truth.
- The skill always makes the standard agent link `.agents/skills` →
  `docs/skills`. The links for single platforms come only from the
  `agent_platforms` module of the configuration (ADR-15).
- Revised all documents of the skill in Simplified Technical English.

### Removed

- `docs/HISTORY.md`. `CHANGELOG.md` replaces the log of what happened (ADR-16).
- `prompts/bootstrap-prompt.md`, `prompts/retro-prompt.md`,
  `prompts/rubric-prompt.md`, and `docs/pi.md`. They stay in the git history.
