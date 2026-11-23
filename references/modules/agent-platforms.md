# Module: Agent Platforms

The standard agent link is a core item. The skill always makes it, also when
this module is off:

```bash
mkdir -p .agents && ln -sfn ../docs/skills .agents/skills
```

Agent platforms that read `.agents/` find the project skills through this link.
This module adds the links for platforms that do not read `.agents/`. The
configuration lists the platforms in `modules.agent_platforms`. The default list
is empty. Keep the list empty unless the project has a platform that does not
read `.agents/`.

## Platform Links

- **`claude`:** Symlinks `.claude/skills/`, and `.claude/agents/` when
  `docs/agents/` is there. File: `CLAUDE.md` with the single line `@AGENTS.md`.
- **`copilot`:** Symlink `.github/agents/` when `docs/agents/` is there.
- **`pi`:** Symlink `.pi/agents/` when `docs/agents/` is there.
- **`opencode`:** Symlink `.opencode/agents/` when `docs/agents/` is there.

Run the commands from the project root. `-n` with `-f` changes a link that is
there. It does not make a link in the target directory.

- **`claude`:** `mkdir -p .claude && ln -sfn ../docs/skills .claude/skills`
- **`claude` (when `docs/agents/` is there):** `ln -sfn ../docs/agents
  .claude/agents`
- **`copilot` (when `docs/agents/` is there):** `mkdir -p .github && ln -sfn
  ../docs/agents .github/agents`
- **`pi` (when `docs/agents/` is there):** `mkdir -p .pi && ln -sfn
  ../docs/agents .pi/agents`
- **`opencode` (when `docs/agents/` is there):** `mkdir -p .opencode && ln -sfn
  ../docs/agents .opencode/agents`

- **Agent links:** make the links to `docs/agents` only when `docs/agents/` is
  there (the `build_agents` module makes it, or the user makes it). A link to a
  directory that is not there is a broken symlink, and `verify.sh` reports it as
  a FAIL.
- **`CLAUDE.md`:** make it only when `claude` is in the list. It contains the
  single line `@AGENTS.md`. This imports `AGENTS.md`, so the instructions have
  one source. If `CLAUDE.md` is there, propose the change, and wait for
  approval.
- **Directories that are there:** if a target path is a directory and not a
  symlink, do not replace it. Propose to move its content into `docs/skills/` or
  `docs/agents/`, and to replace the directory with the symlink. Do this only
  with approval.
- **Windows:** Developer Mode is necessary for symlinks, or
  `core.symlinks=true`. If symlinks do not operate on the system, record this in
  an ADR, and copy the files. Write in `AGENTS.md` that the copies must stay the
  same.

## The same agent files on all platforms

The agent templates use only `name` and `description` in the frontmatter. All
platforms accept these fields. The tool names are different between platforms.
Because of this, the templates do not have `tools`, and the agent gets the
default tools. Add limits for one platform only when the user wants them.
