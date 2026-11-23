# agent-scaffolding

An [Agent Skill](https://agentskills.io) that prepares a project for work with
AI agents. It gives the project a structure that follows best practices:
governance, state documents, project skills, a development environment, and
build agents. You can use it with all languages and all agent platforms.

The skill has two modes:

- **Bootstrap**: scaffolds a new project from an empty directory.
- **Apply**: audits an existing project, gives a gap report, and applies only
  the changes that you accept. It does not overwrite your files without your
  consent.

The agent holds an interview with you. It finds what it can from the project,
and records your answers in `.agent-scaffolding.yml`. Subsequent runs use these
values to apply the scaffold again, or to upgrade it.

## What it installs

**Core** (always):

- `AGENTS.md`: commit modes (AUTONOMOUS or HITL), the Predict → Act → Verify
  workflow, failure modes, CLI boundaries, the git protocol with `Assisted-by:`
  footers, and a pre-commit checklist
- State documents in `docs/`: TASKS, VISION, DECISIONS (ADRs), CONVENTIONS,
  ARCHITECTURE and THIRD-PARTY-NOTICES
- `CHANGELOG.md` at the root: the important changes of the skill, in the Keep a
  Changelog format
- Project skills in `docs/skills/` (`create-skill`, `git`, `state-management`,
  `keepachangelog`), with the specifications that they use (Conventional
  Commits, SemVer, Agent Skills)
- The rules for DRY, document headers, links, and names, plus the import of
  existing documents
- The standard agent link `.agents/skills` → `docs/skills`, so that agent
  platforms find the project skills

**Optional modules** (you select them. The defaults change with the project
type.):

- **`dev_environment`:** A Python venv, or a Podman/Docker Compose container,
  with a skill
- **`build_agents`:** Build and formatter scripts, plus subagent definitions
- **`tool_configs`:** Small linter and formatter configs that agree with the
  installed versions
- **`boilerplate`:** A library, an executable, and tests. The build config alone
  contains the version.
- **`copyright`:** Copyright headers in the source files
- **`agent_platforms`:** Links for agent platforms that do not read
  `.agents/skills`

## Install

Clone the repository into a skills directory. The directory name must be
`agent-scaffolding`. The standard location is `~/.agents/skills/`. Some agent
platforms read their own directory. Put a copy or a link there when it is
necessary for your platform.

Example:

```bash
git clone https://github.com/Deniz-Eren/agent-scaffolding \
  ~/.agents/skills/agent-scaffolding
```

## Use

Start your agent in the target directory. Then tell it to do one of these tasks:

- "Use agent-scaffolding to bootstrap a new Python CLI project here."
- "Apply agent-scaffolding to this repository. Give me the gap report first."
- "Audit this project against agent-scaffolding."

You can also run the scripts in the skill directly:

```bash
# read-only gap report
bash ~/.agents/skills/agent-scaffolding/scripts/audit.sh .
# check of the project against the rules
bash ~/.agents/skills/agent-scaffolding/scripts/verify.sh .
```

For the full procedure, see [SKILL.md](SKILL.md). For the changes in each
version, see [CHANGELOG.md](CHANGELOG.md).

## Development Environment

This project contains only documents and shell scripts. A build system or a
development environment is not necessary. To make sure that the scripts are
correct, run `shellcheck scripts/*.sh assets/repo/scripts/*.sh`. To validate the
skill, run the Agent Skills validator (`agentskills validate <dir>`).

## Repository governance

This repository uses its own conventions. [AGENTS.md](AGENTS.md) and
[docs/](docs/) govern the development of the skill itself. They are not part of
the behavior of the skill.

## License

The MIT License governs this project. See [LICENSE.md](LICENSE.md) for the full
terms.

**Copyright (c) 2026 Deniz Eren <deniz.eren@outlook.com>**

The specifications in `references/specs/` are part of this skill. They keep the
licenses of their sources. See
[docs/THIRD-PARTY-NOTICES.md](docs/THIRD-PARTY-NOTICES.md).
