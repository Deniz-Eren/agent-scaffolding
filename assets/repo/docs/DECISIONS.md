## Purpose

Record the decisions about the architecture and the strategy of {{PROJECT_NAME}}. Give the context, the alternatives, and the consequences.

## Structure

Each decision is a block with the sections `Context`, `Decision`, `Alternatives`, and `Consequences`. You can read the block alone. The blocks are in groups by category. The ADRs are newest first (git log order).

## Formatting Rules

- Heading: `## ADR-N (YYYY-MM-DD): Title`, where N is the next sequential number.
- Subsections: `### Context`, `### Decision`, `### Alternatives`, `### Consequences`.
- The ADRs are newest first (git log order). Put a new ADR at the top of the file, below the `<!-- [CAT] Category -->` comment of its category.
- To replace a decision, add a new ADR that supersedes it. Do not change the old ADR.

<!-- [CAT] Governance -->

## ADR-1 ({{DATE}}): Adopt agent-scaffolding

### Context

The project must have governance, documentation, and agent instructions that work with all AI agents.

### Decision

Apply the agent-scaffolding agent skill {{SKILL_VERSION}} with the configuration in `.agent-scaffolding.yml`. The commit mode is {{COMMIT_MODE}}.

### Alternatives

- Documents and agent instructions that you write for each project
- Instructions for one platform only (for example only `CLAUDE.md` or only `.github/copilot-instructions.md`)

### Consequences

- `AGENTS.md` is the supreme authority for agent behavior.
- Procedures are only in `docs/skills/`.
- The state documents (`TASKS.md`, `CHANGELOG.md`, and `DECISIONS.md`) are up to date before each commit.
