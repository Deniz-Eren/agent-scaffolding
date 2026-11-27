---
name: agent-scaffolding
description: >
  Bootstrap a new project, or apply the skill to an existing project. The
  scaffold that it makes is prepared for agents and follows best practices. It
  includes AGENTS.md governance (commit modes, the git protocol with Assisted-by
  footers, git hooks with an installer script, a pre-commit checklist). It also
  includes state documents (TASKS, DECISIONS, ARCHITECTURE, CONVENTIONS), a
  changelog, and project skills that obey the Agent Skills spec. Optional parts
  add an isolated development environment, build and format subagents, tool
  configs, copyright headers, and agent platform links. This skill applies when
  the user tells you to scaffold or bootstrap a project for AI agents. It also
  applies when the user tells you to add AGENTS.md or agent governance, or to
  audit a repository against these conventions.
license: MIT
compatibility: >
  Git and bash are necessary. Optional tools are podman or docker (development
  environments in containers) and python3 (development environments on the
  host). You can use the skill with all agents that can read files and run shell
  commands.
metadata:
  author: Deniz Eren
  version: "0.3.0"
---

# agent-scaffolding

This skill prepares a project for safe work by humans and AI agents. It gives
the same procedures for all languages and all agent platforms. It has two modes:
**bootstrap** (a new project) and **apply** (an existing project).

> **Scope:** the content of the skill is this file, [references/](references/),
> [assets/](assets/), and [scripts/](scripts/). This repository also contains
> `AGENTS.md` and `docs/`. They govern the development of the skill itself. They
> are **not** instructions for the target project. Do not obey them unless you
> change this skill.

In the paths in this document, `$SKILL` is the directory that contains this
file. The **target** is the project that you scaffold. The target is usually the
current working directory. Do not write files into `$SKILL`.

## Workflow

### 1. Select the mode

Run the read-only audit:

```bash
bash "$SKILL/scripts/audit.sh" <target>
```

- **bootstrap** ([references/BOOTSTRAP.md](references/BOOTSTRAP.md)): the target
  has no source files and no build manifest. It has only files such as `README`,
  `LICENSE`, or documents to import. It is not a git repository, or it has no
  commits.
- **apply** ([references/APPLY.md](references/APPLY.md)): all other targets.
- **apply (run it again, or upgrade)**
  ([references/APPLY.md](references/APPLY.md)): the target has
  `.agent-scaffolding.yml`.

Tell the user which mode you found. Let the user confirm it.

### 2. Interview

Obey [references/INTERVIEW.md](references/INTERVIEW.md):

1. Find the values first.
2. Put questions to the user only about the values that are missing or not
   clear.
3. Let the user select the optional modules.
4. Write `.agent-scaffolding.yml` in the target.

### 3. Read the rules

Read [references/RULES.md](references/RULES.md). These rules always apply. Then
read only the module files for the selected modules:

- **`dev_environment`**
  ([modules/dev-environment.md](references/modules/dev-environment.md)):
  Isolated environment: Python venv, or Podman/Docker Compose container.
- **`build_agents`**
  ([modules/build-agents.md](references/modules/build-agents.md)): Build and
  formatter scripts, plus subagent definitions that run before each build.
- **`tool_configs`**
  ([modules/tool-configs.md](references/modules/tool-configs.md)): Small linter
  and formatter configs that agree with the installed versions.
- **`boilerplate`**
  ([modules/boilerplate.md](references/modules/boilerplate.md)): Code skeleton
  with library, executable, and tests. The build config alone contains the
  version.
- **`copyright`** ([modules/copyright.md](references/modules/copyright.md)):
  Copyright headers and their formats in CONVENTIONS.md.
- **`agent_platforms`**
  ([modules/agent-platforms.md](references/modules/agent-platforms.md)): Links
  for agent platforms that do not read `.agents/`.

### 4. Execute

Run the workflow of the selected mode:

- **Bootstrap:** five phases, with one atomic commit for each phase.
- **Apply:** preflight → audit → gap report → apply only the items with user
  approval → verify. Do not overwrite a file without consent.

Make the target files from the templates in [assets/repo/](assets/repo/). Put
the values into the `{{PLACEHOLDERS}}`. Keep or remove the `<!-- module:x -->`
blocks. Change the text to agree with the project.

### 5. Verify and give a report

```bash
bash "$SKILL/scripts/verify.sh" <target>
```

Repair all `FAIL` results, then complete the manual checklist in
[references/VERIFICATION.md](references/VERIFICATION.md). Then give a report.
The report contains:

- The files that it created or changed
- The modules that are on
- The output of the verify step
- The ADRs that it recorded
- The next steps

## Rules that you must always obey

- **Git:** give the identity inline with `-c user.name=… -c user.email=…`. Read
  the name and the email from the configuration. The value `current_user` means
  the git configuration of the current user. Use Conventional Commits. End each
  message with an `Assisted-by: <agent>:<model>` footer that gives the name of
  the agent and the model of the current session. Install and use the
  `pre-commit` and `commit-msg` git hooks (`scripts/install-git-hooks.sh`). In
  AUTONOMOUS mode, use `--no-gpg-sign`. In HITL mode, stop and print `WAITING
  FOR GPG SIGNATURE`. Do not push without approval.
- **Safety:** do not overwrite, erase, or rename a file of the user without
  clear approval. If the working tree is not clean, stop, and put your question
  to the user first.
- **Paths:** write `~` or `$HOME`. Do not write an absolute home path.
- **Integrity:** do not commit when the build is not correct or when the tests
  are not correct. A tool config that the tool does not accept counts as a build
  failure.
- **DRY:** procedures are only in `docs/skills/*/SKILL.md` in the target
  project. Other files link to them.

## Files in the skill

- [references/specs/](references/specs/): Specifications that target projects
  get as copies with no changes: Conventional Commits, SemVer 2.0.0, and Agent
  Skills. The attribution entries are in
  [references/SPEC-NOTICES.md](references/SPEC-NOTICES.md).
- [assets/repo/](assets/repo/): Templates for `AGENTS.md`, `README.md`,
  `.gitignore`, `.agent-scaffolding.yml`, and the state documents in `docs/`. It
  also contains the core skills, agent definitions, git hooks, hook installer,
  and script skeletons.
- [scripts/audit.sh](scripts/audit.sh): Read-only gap report.
- [scripts/verify.sh](scripts/verify.sh): A check that the target agrees with
  the rules. After a failure, the exit code is not 0.
- [CHANGELOG.md](CHANGELOG.md): The changes between the versions of the skill.
  Use it when you upgrade a project in apply mode.
