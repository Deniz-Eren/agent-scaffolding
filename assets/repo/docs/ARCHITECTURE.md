## Purpose

Write the architecture of {{PROJECT_NAME}} in this document. Write the files, their structure, and the task of each component.

## Structure

The document has a system overview, the directory structure, component descriptions, and the integration points.

## Formatting Rules

- Write about the current condition only. Put decisions in [DECISIONS.md](DECISIONS.md).
- Use code blocks for directory trees.
- Link to skill files for procedures. Do not write the procedures here.

---

## System Overview

<!-- What the project is, and its main components. -->

## Directory Structure

```
/
├── AGENTS.md            ← Governance for AI agents (supreme authority)
├── README.md            ← Entry point
├── CHANGELOG.md         ← Changes between versions
├── .agent-scaffolding.yml ← Scaffolding configuration
├── scripts/
│   ├── install-git-hooks.sh ← Installs git hooks from scripts/hooks/
│   └── hooks/           ← Tracked pre-commit and commit-msg hooks
└── docs/
    ├── ARCHITECTURE.md  ← This file
    ├── DECISIONS.md     ← ADRs
    ├── CONVENTIONS.md   ← Names, formatting, copyright
    ├── TASKS.md         ← Task records
    ├── THIRD-PARTY-NOTICES.md
    ├── VISION.md        ← Mission and principles
<!-- module:build_agents -->
    ├── agents/          ← Subagent definitions
<!-- /module:build_agents -->
    └── skills/          ← Agent skills
```

## Component Descriptions

| Component | Purpose |
|---|---|
| <!-- path --> | <!-- purpose --> |

## Integration Points

| Component | References | Used By |
|---|---|---|
| `AGENTS.md` | `docs/skills/git`, `docs/skills/state-management` | All agent platforms |
| `scripts/install-git-hooks.sh` | `scripts/hooks/pre-commit`, `scripts/hooks/commit-msg` | Local git hooks directory |
| `.agents/skills` | `docs/skills` (symlink) | Agent platforms (skill discovery) |
<!-- module:agent_platforms -->
| `.claude/`, `.github/`, `.pi/`, `.opencode/` | Symlinks to `docs/skills` and `docs/agents` | Platforms that do not read `.agents/` |
<!-- /module:agent_platforms -->
