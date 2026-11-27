# Architecture

## Purpose

Write the architecture of the agent-scaffolding repository in this document.
Write the files, their structure, and the task of each component.

## Structure

The document has a system overview, the directory structure, component
descriptions, and the integration points.

## Formatting Rules

- Use code blocks for directory trees.
- Keep the descriptions short, and link to skill files for procedures.
- Do not record decisions here. Use [DECISIONS.md](DECISIONS.md).

---

## System Overview

The repository root is an [Agent Skill](https://agentskills.io) with the name
`agent-scaffolding`. To install it, clone the repository as `agent-scaffolding/`
into a skills directory. An agent reads `SKILL.md` first. Then it loads the
reference files, the templates, and the scripts that are necessary (it reads
more files only when they are necessary).

The repository also contains its own governance (`AGENTS.md` and `docs/`). It
applies the skill to itself, as recorded in `.agent-scaffolding.yml`.

---

## Directory Structure

```
/
├── SKILL.md               ← Skill entry point: frontmatter, workflow, index
├── README.md              ← For people: install, operation, overview
├── CHANGELOG.md           ← Skill versions (for upgrades in apply mode)
├── LICENSE.md             ← MIT (IMMUTABLE)
├── AGENTS.md              ← Governance for contributors to this repository
├── .agent-scaffolding.yml ← Configuration of this repository for the skill
├── .agents/skills         ← Standard symlink to docs/skills
├── references/            ← Loaded on demand by the agent
│   ├── INTERVIEW.md       ← Auto values, questions, defaults, placeholders
│   ├── BOOTSTRAP.md       ← New-project workflow (5 phases)
│   ├── APPLY.md           ← Existing-project workflow (audit, approval, apply)
│   ├── RULES.md           ← Hard rules that always apply
│   ├── VERIFICATION.md    ← verify.sh results and manual checklist
│   ├── SPEC-NOTICES.md    ← Attribution entries for specs (copied into targets)
│   ├── modules/           ← One file for each optional module
│   └── specs/             ← IMMUTABLE specs: COMMITS.md, semver.md, SKILLS.mdx
├── assets/repo/           ← Files copied into target projects
│   ├── AGENTS.md, README.md, gitignore, agent-scaffolding.yml
│   ├── docs/              ← The 7 state documents
│   ├── skills/            ← create-skill, git, state-management,
│   │                         dev-environment, keepachangelog
│   ├── agents/            ← build.md, format-validator.md
│   └── scripts/           ← build-agent.sh, formatter-agent.sh, enter-dev.sh,
│                             install-git-hooks.sh, hooks/ (pre-commit, commit-msg)
├── scripts/
│   ├── audit.sh           ← Read-only gap report for a target directory
│   ├── verify.sh          ← Check of a target directory against the rules
│   ├── install-git-hooks.sh ← Installs hooks from scripts/hooks/
│   └── hooks/             ← Tracked pre-commit and commit-msg hooks
└── docs/                  ← State documents of the repository
    ├── TASKS.md, VISION.md, DECISIONS.md
    ├── CONVENTIONS.md, ARCHITECTURE.md, THIRD-PARTY-NOTICES.md
    └── skills/            ← Project skills, made from the templates
        ├── create-skill/  ← references/SKILLS.mdx → references/specs/
        ├── git/           ← COMMITS.md, semver.md → references/specs/
        ├── keepachangelog/← Keep a Changelog procedure for CHANGELOG.md
        └── state-management/
```

---

## Component Descriptions

### Skill content

- **`SKILL.md`:** Selects the mode (bootstrap or apply). Runs the interview.
  Reads the rules and the selected modules. Runs the workflow. Verifies the
  result.
- **`references/RULES.md`:** Configuration, home paths, the DRY matrix,
  AGENTS.md sections, the git protocol, root files, document headers, links,
  names, document tasks, skills, pre-existing documents, build integrity,
  templates, and safety.
- **`references/modules/*.md`:** `dev-environment`, `build-agents`,
  `tool-configs`, `boilerplate`, and `copyright`.
- **`assets/repo/`:** Complete files with `{{PLACEHOLDERS}}` and module blocks.
  The agent puts the values into them and changes them.
- **`scripts/audit.sh`:** Reports OK, MISSING, CHECK, and INFO for each core
  item and module item. It does not write.
- **`scripts/verify.sh`:** Reports PASS, WARN, and FAIL. After a FAIL, the exit
  code is not 0. It obeys `exclude_paths` in the config of the target.
- **`scripts/install-git-hooks.sh` and `scripts/hooks/`:** Install and run the
  `pre-commit` and `commit-msg` git hooks for this repository.

### Repository governance

- **`AGENTS.md`:** Made from the template, plus the repository scope, the
  IMMUTABLE files, and the validation steps.
- **`docs/*.md`:** State documents (tasks, decisions, and other records).
- **`docs/skills/*`:** Made from `assets/repo/skills/`. The spec references are
  symlinks to `references/specs/`.

---

## Integration Points

- **Agent platforms → `SKILL.md`:** The platforms find the skill in the skills
  directory of the user (the standard is `~/.agents/skills/`).
- **`SKILL.md` → `references/`, `assets/`, `scripts/`:** Relative links. The
  agent reads them from the skill directory (`$SKILL`).
- **`references/BOOTSTRAP.md` → `references/specs/`,
  `docs/THIRD-PARTY-NOTICES.md`:** The skill copies the specs and their
  attribution into the target.
- **`scripts/verify.sh` → Target `.agent-scaffolding.yml`:** Reads `modules` and
  `exclude_paths`.
- **`.agents/skills` → `docs/skills/`:** Standard symlink for agents that change
  this repository.
