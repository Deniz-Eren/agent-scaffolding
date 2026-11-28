## Purpose

Record the decisions about the architecture and the strategy of the project.
Give the context, the alternatives, and the consequences.

## Structure

Each decision is a block with the sections `Context`, `Decision`,
`Alternatives`, and `Consequences`. You can read the block alone. The ADRs are
newest first (git log order).

## Formatting Rules

- Heading: `## ADR-N (YYYY-MM-DD): Title`, where N is the next sequential
  number.
- Subsections: `### Context`, `### Decision`, `### Alternatives`, and `###
  Consequences`.
- The ADRs are newest first (git log order). Put a new ADR at the top of the
  file, below the `<!-- [CAT] Category -->` comment of its category.
- To replace a decision, add a new ADR that supersedes it. Do not change the old
  ADR.
- Keep the decisions short. `CHANGELOG.md` records the changes between releases.

<!-- [CAT] Governance -->

## ADR-25 (2026-11-28): Specialize Git Hooks per Project and Check Before Installing

### Context

Generic git hook templates cannot know project-specific rules from other active
skills (for example maximum line length, prose line packing, file headers, or
traceability checks from `docs-traceability-setup`). Also, `AGENTS.md` must
tell agents to check hook installation on the repository instance before they
run the installer one time.

### Decision

- `AGENTS.md` tells agents to run `scripts/install-git-hooks.sh` one time on
  each repository instance and to check that the hooks are not installed before
  installing (`scripts/install-git-hooks.sh --check`).
- `scripts/install-git-hooks.sh` checks each hook before installing, skips
  hooks that are installed, and accepts `--check` for a read-only check.
- `RULES.md`, `BOOTSTRAP.md`, `APPLY.md`, `VERIFICATION.md`, the `git` skill,
  and the hook templates require project-specific hooks. Agents must specialize
  `scripts/hooks/pre-commit` and `scripts/hooks/commit-msg` for the target
  project and its other active skills.
- `scripts/hooks/pre-commit` checks all project documents against project and
  active-skill rules (such as line length, prose line packing, and headers).
  `scripts/hooks/commit-msg` obeys the same applicable text rules in addition to
  the `git` skill rules.

### Alternatives

- Keep generic hook templates with no specialization requirement (misses rules
  from other active skills and project conventions)
- Re-install hooks unconditionally on each run (does unnecessary writes and
  gives no read-only check option for agents)

### Consequences

- Target repositories get hooks tailored to their full rule set, including
  other skills used in the project.
- `assets/repo/scripts/hooks/commit-msg` includes a `# TODO:` marker for
  project-specific rules, so `scripts/verify.sh` warns if an agent copies it
  without specialization.

<!-- [CAT] Governance -->

## ADR-24 (2026-11-28): Core Git Hooks for Pre-Commit and Commit-Msg Checks

### Context

Target repositories documented pre-commit checks and commit message rules in
`AGENTS.md` and `docs/skills/git/SKILL.md`, but they had no local git hooks to
check these rules automatically. Contributors and agents can commit with
formatting errors, test failures, documentation errors, or invalid commit
messages.

### Decision

- Make `pre-commit` and `commit-msg` git hooks a core item of the `git` skill
  and all scaffolded repositories.
- Keep the tracked hook scripts in `scripts/hooks/pre-commit` and
  `scripts/hooks/commit-msg`, with templates in `assets/repo/scripts/hooks/`.
- Give each repository an executable installer script
  `scripts/install-git-hooks.sh` (template:
  `assets/repo/scripts/install-git-hooks.sh`). It installs all hooks in
  `scripts/hooks/` into the local git hooks directory.
- `scripts/hooks/pre-commit` runs formatter checks, tests, and documentation
  checks before each commit.
- `scripts/hooks/commit-msg` uses portable bash and POSIX tools to validate
  Conventional Commits headers, allowed types, and empty-line separation. It
  also checks uppercase `BREAKING CHANGE:` tokens and the `Assisted-by:` footer
  in the last trailer block. For commits with no AI help, set
  `ALLOW_NO_ASSISTED_BY=1`.
- `scripts/audit.sh` and `scripts/verify.sh` verify that the installer and the
  two hook scripts are there and executable. `verify.sh` gives a warning when
  the hooks are not installed in the local git hooks directory.

### Alternatives

- Put git hooks in an optional module (then target repositories can skip local
  checks of core git skill rules)
- Configure `core.hooksPath` in local git config (changes git config and
  replaces other local user hooks, and does not install individual hook files)
- Use an external hook manager such as `pre-commit` or `husky` (adds a Python
  or Node.js runtime dependency to projects that use only git and bash)

### Consequences

- All scaffolded repositories get tracked, dependency-free git hooks and a
  single script to install them.
- `scripts/verify.sh` reports a `FAIL` when `scripts/install-git-hooks.sh`,
  `scripts/hooks/pre-commit`, or `scripts/hooks/commit-msg` is missing or not
  executable.
- Projects that upgrade from earlier skill versions get the new hook scripts
  and git skill section in apply mode.

<!-- [CAT] Documentation -->

## ADR-23 (2026-11-19): The Name of the Standards Document Is CONVENTIONS.md

### Context

The document `docs/STANDARDS.md` records the conventions of the project: file
names, document formatting, and copyright rules. The name `CONVENTIONS.md`
describes this content.

### Decision

The document has the name `docs/CONVENTIONS.md`. The template is
`assets/repo/docs/CONVENTIONS.md`. The document uses the word conventions, not
standards. Earlier records (ADRs, the changelog, and the git history) keep the
earlier name.

### Alternatives

- Keep `STANDARDS.md` (a name that suggests fixed rules with no exceptions)

### Consequences

- All current documents and scripts use the new name.

<!-- [CAT] Governance -->

## ADR-22 (2026-11-19): AGENTS.md Defers the Commit Mode to the Configuration

### Context

`AGENTS.md` repeated the behavior of the commit modes and the `--no-gpg-sign`
flag. The configuration (`operations.commit_mode`) is the single source of truth
for these settings (ADR-17). Two sources can become different.

### Decision

- `AGENTS.md` does not define the commit modes and does not name the signature
  flag. It gives the location of the setting (`operations.commit_mode` in
  `.agent-scaffolding.yml`) and links to the git skill for the procedure.
- The git skill defines the behavior of the modes, their signature rules, and
  their typical work types.

### Alternatives

- Keep the mode table in `AGENTS.md` (the same information in two places)

### Consequences

- A change of the mode semantics is a change of the git skill only. A change of
  the mode of the project is a change of the configuration only.
- `verify.sh` no longer demands the mode table, the HITL section, and the
  signature text in `AGENTS.md`.

<!-- [CAT] Documentation -->

## ADR-21 (2026-11-19): The Changelog and the Decisions Are Newest First

### Context

`CHANGELOG.md` had the releases newest first, but the entries inside a section
had no fixed order. `docs/DECISIONS.md` had the ADRs oldest first. Readers must
scroll to the end to find the latest information.

### Decision

- `CHANGELOG.md` and `docs/DECISIONS.md` put the newest entries first (git log
  order).
- The two files start with the sections `Purpose`, `Structure`, and `Formatting
  Rules`, as the other state documents do.
- A new ADR goes to the top of `docs/DECISIONS.md`, below the `<!-- [CAT]
  Category -->` comment of its category.
- The templates and the skills (keepachangelog, state-management) document the
  same rules.

### Alternatives

- Keep the ADRs oldest first (a reading order like a story, but the latest
  decision is at the end)

### Consequences

- The latest changes and decisions are at the top. The ADR numbers keep the
  creation order; the file order is the reverse.

<!-- [CAT] Governance -->

## ADR-20 (2026-11-19): The Identity Configuration Names the Current User

### Context

`identity.git_author_name` and `identity.git_author_email` contained a fixed
name and email. The fixed values are wrong when another person works in the
project.

### Decision

- The identity fields accept the value `current_user`. It means the identity of
  the current user. The agents take the name and the email from the git
  configuration of the environment (`git config user.name`, `git config
  user.email`).
- The configuration template contains `current_user` as the default value. A
  project can put a fixed name and email into the fields.
- The agents give the identity inline with `-c` as before. They do not change
  git config.

### Alternatives

- Remove the identity fields and always use the git configuration (the
  configuration is then not the one source of truth)
- Keep a fixed identity in each configuration (a wrong author when another
  person works in the project)

### Consequences

- The commit author is the person whose git configuration the environment has.
  The `Assisted-by:` footer continues to name the agent and the model of the
  session (ADR-11).
- The placeholders `{{GIT_AUTHOR_NAME}}` and `{{GIT_AUTHOR_EMAIL}}` are gone
  from the configuration template.

<!-- [CAT] Architecture -->

## ADR-19 (2026-11-19): The Templates Live in assets/repo

### Context

The templates were in `assets/templates/`. The directory tree below them is a
copy of the target repository, but the name `templates` did not show this.

### Decision

The template directory is `assets/repo/`. The directory tree below
`assets/repo/` matches the root of the target repository (`AGENTS.md`,
`README.md`, `docs/`, `scripts/`, and the other files). Earlier records (ADRs,
the changelog, and the git history) keep the path `assets/templates/`.

### Alternatives

- Keep `assets/templates/` (the name says what the files are, not where they go)

### Consequences

- All references in the skill documents use the new path. The `exclude_paths`
  configuration of this repository uses `assets/repo`.

<!-- [CAT] Architecture -->

## ADR-18 (2026-11-17): The New Name of the Project Is agent-scaffolding

### Context

The name `llm-scaffolding` suggests that the skill scaffolds large language
models. The skill scaffolds projects for AI agents. The name `agent-scaffolding`
is correct for this task.

### Decision

The project and the skill have the name `agent-scaffolding`. The configuration
file is `.agent-scaffolding.yml`. The directory of the skill is
`agent-scaffolding/`. Earlier records (ADRs, tasks, and the git history) keep
the earlier name.

### Alternatives

- Keep `llm-scaffolding` (a name that suggests a different subject)

### Consequences

- All current documents, templates, and scripts use the new name. The name in
  `SKILL.md` and the name of the skill directory are the same, as the Agent
  Skills specification says.
- The local directory of this repository and the remote repository must get a
  rename to `agent-scaffolding` (a manual step).

## ADR-17 (2026-11-17): One Config Source for Commit Mode and Identity

### Context

The git skill and `AGENTS.md` had the commit mode and the git identity as
literal values. The same values are in `.agent-scaffolding.yml`
(`operations.commit_mode`, `identity.git_author_name`,
`identity.git_author_email`). Two copies can become different.

### Decision

The git skill and `AGENTS.md` read the commit mode and the identity from
`.agent-scaffolding.yml`. They do not contain the values. `AGENTS.md` gives the
procedure, and the configuration gives the values.

### Alternatives

- Keep the values in `AGENTS.md` (a second copy that can become different from
  the configuration)

### Consequences

- One source for the values. A change of the mode or of the identity is then
  only a change of the configuration.
- The placeholders `{{GIT_AUTHOR_NAME}}` and `{{GIT_AUTHOR_EMAIL}}` are only in
  the configuration template. The placeholder `{{COMMIT_FLAG}}` is gone.

## ADR-16 (2026-11-17): CHANGELOG.md Replaces HISTORY.md

### Context

The skill made `docs/HISTORY.md`, a log with categories, for each target
project. `CHANGELOG.md` in the Keep a Changelog format is the standard procedure
to record the changes of a project. A release appeared in the two files. Some
changes appeared in the two files.

### Decision

- The skill makes `CHANGELOG.md` at the project root. The format is the Keep a
  Changelog format: one section for each version, and an `## [Unreleased]`
  section between releases. The category headings are `Added`, `Changed`,
  `Deprecated`, `Removed`, `Fixed`, and `Security`.
- The new core skill `keepachangelog` gives the procedure. The skill no longer
  makes `docs/HISTORY.md`.
- The rules that wrote to HISTORY.md write to `CHANGELOG.md` in `##
  [Unreleased]`.
- The keepachangelog skill gives the format with its own words. It says that the
  THIRD-PARTY-NOTICES.md of the target must have the attribution entry for
  keepachangelog.com.
- This repository moved the content of its `docs/HISTORY.md` into `CHANGELOG.md`
  and removed the file.

### Alternatives

- Keep the two files (two records for the same changes, and a rule for the file
  of each change)
- Keep HISTORY.md and record only releases in CHANGELOG.md (agents must then
  select the file for each change, and the two files stay)

### Consequences

- One file for the changes of a project. A release moves the content of `##
  [Unreleased]` into a new version section.
- `audit.sh` and `verify.sh` check `CHANGELOG.md` as a core item, and they no
  longer check `docs/HISTORY.md`.

## ADR-15 (2026-11-17): The Standard Agent Link Is the Default

### Context

Agent platforms find the skills of a project in different directories. The
standard location is `.agents/skills/` in the project. A link for one platform
(for example `.claude/` or `.github/`) is necessary only for a platform that
does not read the standard location. ADR-10 made the links for all platforms in
all projects.

### Decision

- The skill always makes the standard link `.agents/skills` → `docs/skills`. It
  is a core item, and `audit.sh` and `verify.sh` check it for all projects.
- The `agent_platforms` module stays a configuration item for target projects.
  It adds the links of
  [modules/agent-platforms.md](../references/modules/agent-platforms.md) only
  for the platforms in its list. The default list is empty.
- This repository sets `agent_platforms: []`, and it has only the standard link.
  It has no `CLAUDE.md` and no `.claude/` directory. This supersedes ADR-10 for
  the default behavior and for this repository.

### Alternatives

- Links for all platforms in all projects (files for platforms that the project
  does not use, and more maintenance)
- No link at the root (agent platforms do not find the project skills)

### Consequences

- One standard configuration in all projects. For a platform that does not read
  `.agents/`, an entry in `modules.agent_platforms` is necessary.
- The links for one platform come only from the configuration. `verify.sh`
  checks them only when the module is on.

## ADR-14 (2026-11-16): Changes from the End-to-End Test Runs

### Context

Three test runs (a documentation project, a Python project with all modules, and
an apply run on a repository with files) gave correct `verify.sh` results. But
the agents reported problems: the bootstrap sequence made sure of the tool
versions before the development environment was there. README and ARCHITECTURE
were written before the skills and agents that they list. The spec notices
pointed into the `docs/` of this repository. `verify.sh` did not find missing
module files, missing copyright headers, or template text in source files.

### Decision

- Change the sequence in BOOTSTRAP: the development environment comes before the
  tool configs. README, ARCHITECTURE, and the platform links come in the last
  phase. The skill adds the copyright headers when it makes each file.
- Ship the spec attribution entries in `references/SPEC-NOTICES.md`, which is
  part of the skill.
- `verify.sh` gives a FAIL for missing module files (build and formatter agents,
  platform links, `CLAUDE.md`), for missing copyright headers, and for template
  text in source and config files. It gives a WARN for template comments that
  stay in the files, and for commits with no `Assisted-by:` after the skill was
  applied.
- Put the template lines for the modules behind module markers. Add
  `{{LICENSE_FILE}}` and a section with the rules for the project to the
  templates.

### Alternatives

- Keep the checks only in the manual checklist (the test runs showed that agents
  skip them)

### Consequences

- `verify.sh` gives more FAIL results on projects that the skill scaffolded with
  earlier versions of the templates.
- The `AGENTS.md` of this repository moved its rules for the repository into the
  section with the rules for the project.

## ADR-13 (2026-11-16): The Markdown Checks of verify.sh Do Not Flag Examples

### Context

Documents that tell the rules must show the syntax that is not permitted, for
example a link in backticks or a placeholder marker. A simple check flags these
examples.

### Decision

- A link in backticks is a FAIL only when its target is a URL or a path that is
  there. If not, it is an example of the syntax.
- The check for broken links and the check for template text do not look at code
  spans in Markdown. The check looks at fenced code blocks for template text.
- Because of this, templates do not put a placeholder in a code span.

### Alternatives

- Use an ignore comment for each line (much noise in the files)
- Skip the document files (the check then misses errors)

### Consequences

- Documents with rules can show the syntax that is not permitted, and the check
  finds the errors.

## ADR-12 (2026-11-16): Configuration of the Skill on This Repository

### Context

The repository applies its own skill to itself. It contains the sources of the
templates with placeholders, and the specs with no changes.

### Decision

- `.llm-scaffolding.yml`: type `documentation`, commit mode AUTONOMOUS, only the
  module `agent_platforms` (`.agents/skills`, `.claude/skills`, `CLAUDE.md`).
  There is no development environment and there are no build agents. Because of
  this, the skill removed the `dev-environment` skill.
- `exclude_paths: [assets/templates, references/specs]`. `verify.sh` does not
  look at these paths in its checks. This config key is part of the skill.
- The skill generates `AGENTS.md` and `docs/skills/*` from the templates. The
  spec references in `docs/skills/*/references/` are symlinks to
  `references/specs/`, so the specs are not there two times.
- `THIRD-PARTY-NOTICES.md` stays in `docs/`, as the templates define. It ships
  with the skill, because the full repository is the skill.

### Alternatives

- The repository does not obey its own rules
- Copy the specs into `docs/skills/*/references/` (the IMMUTABLE files are then
  there two times)

### Consequences

- `scripts/verify.sh .` must be correct on this repository before each commit.

## ADR-11 (2026-11-16): Assisted-by Names the Agent of the Current Session

### Context

`AGENTS.md` kept one agent name and model for the `Assisted-by:` footer
(`pi-agent`, `Qwen3.6-35B-A3B-UD-Q4_K_XL`). When a different agent or model made
a commit, the footer was incorrect.

### Decision

The `Assisted-by:` footer always gives the agent and the model of the current
session. `AGENTS.md` and the templates do not keep an agent identity.

### Alternatives

- Keep an identity in the file and change it by hand (the information becomes
  not correct)

### Consequences

- The attribution of the commits is correct for all agents and models.

## ADR-10 (2026-11-16): The Platforms Find the Skills through Symlinks

### Context

GitHub Copilot, Claude Code, Pi, and OpenCode find the skills and agents of a
project in different directories. A copy of the files in each directory breaks
DRY.

### Decision

- The skills are in `docs/skills/` and the agents are in `docs/agents/`.
  Relative symlinks (`.agents/skills`, `.claude/skills`, `.claude/agents`,
  `.github/agents`, `.pi/agents`, `.opencode/agents`) connect them to each
  platform. `CLAUDE.md` contains only `@AGENTS.md`.
- Agent definitions use only `name` and `description` in the frontmatter. The
  tool names are different between platforms, so `tools` is not there.
- The skill makes the agent links only when `docs/agents/` is there.
- The nested `SKILL.md` files (in `docs/skills/` and `assets/templates/skills/`)
  are not found when the skill is installed. Pi and OpenCode go into the
  directories only until the first directory that contains `SKILL.md` (the team
  verified this in their source code). Claude Code and Copilot look at only one
  level.

### Alternatives

- Copy the files into each directory of the platforms (the same content two
  times, and the copies become different in time)
- Work with only one platform

### Consequences

- One source for each skill and agent. On Windows, Developer Mode is necessary
  for symlinks. If symlinks do not operate, use copies, and record an ADR.

## ADR-9 (2026-11-16): Pivot from a Bootstrap Prompt to an Agent Skill

### Context

The deliverable was `prompts/bootstrap-prompt.md`, a prompt with 459 lines. The
user had to change its tables by hand, and it bootstrapped only **new**
projects. Agent platforms have [Agent Skills](https://agentskills.io), which
load the instructions when they are necessary.

### Decision

- The repository root is the Agent Skill `llm-scaffolding` (`SKILL.md`,
  `references/`, `assets/templates/`, and `scripts/`).
- There are two modes: **bootstrap** (a new project) and **apply** (a project
  with files: audit → gap report → apply only the items with approval. No
  overwrite without consent.)
- The values come from an interview. The interview finds many values from the
  project. The skill keeps the answers in the `.llm-scaffolding.yml` of the
  target.
- A core that always applies, plus optional modules: `dev_environment`,
  `build_agents`, `tool_configs`, `boilerplate`, `copyright`, and
  `agent_platforms`.
- The skill removed `prompts/` (the bootstrap, retro, and rubric prompts) and
  `docs/pi.md`. The user gave approval. They stay in the git history.
- The IMMUTABLE specs moved with no changes from `docs/` to `references/specs/`,
  so that the skill ships them.
- The version starts at 0.1.0 (`metadata.version` in SKILL.md). `CHANGELOG.md`
  records the changes for upgrades.

### Alternatives

- Keep the prompt and add a skill around it (two deliverables that must stay the
  same)
- Put the skill in a subdirectory (then nobody can clone the repository root as
  the skill)
- Write all rules as prose only (no templates and no verification script)

### Consequences

- Agents can scaffold projects and add the scaffold to projects with files. The
  user does not change a prompt.
- The governance of the repository (`AGENTS.md`, `docs/`) installs with the
  skill. `SKILL.md` tells agents to ignore it.
- The manual retro and rubric loop is not part of the skill. `scripts/verify.sh`
  replaces the rubric. It verifies what a computer can verify.
