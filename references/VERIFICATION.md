# Verification

Verification has two parts: a check by the script `scripts/verify.sh`, then a
short manual check. Run it at the end of the bootstrap and apply workflows. Run
it also when the user wants to know if a project agrees with the rules.

## Check by script

```bash
# checks of the structure
<skill-dir>/scripts/verify.sh <target-dir>
# also runs build-agent.sh and formatter-agent.sh
<skill-dir>/scripts/verify.sh <target-dir> --with-build
```

Delegate the build and the format runs to the build and format-validator agents
when you can. Use `--with-build` only when the platform has no subagents.

The script reports `FAIL` for these conditions:

- **Config:** `.agent-scaffolding.yml` is missing.
- **Doc headers:** One of the 6 scaffolding documents is missing, or it does not
  have one `## Purpose`, one `## Structure`, and one `## Formatting Rules` in
  this sequence. The check does not look at fenced code blocks.
- **README:** The heading `## License` is missing. The heading `## Development
  Environment` is missing while `dev_environment` is on.
- **AGENTS.md:** A necessary `##` section heading, the text `WAITING FOR GPG
  SIGNATURE`, or `Assisted-by:` is missing (see [RULES.md
  §4](RULES.md#4-agentsmd-has-the-highest-authority)).
- **Template text:** A `{{PLACEHOLDER}}` or a `<!-- module:` marker stays in a
  text file (Markdown, scripts, YAML, TOML, JSON, INI, and the usual source and
  build files). The check does not look at code spans in Markdown.
- **Links:** A link is in backticks, or a relative link points to a file that is
  not there.
- **Home paths:** `/home/<user>/` or `/Users/<user>` is in a generated file.
- **Skills:** A core skill is missing. Or: the name is not the same as the
  directory name, the name is not correct, or the description is empty or too
  long.
- **Modules:** A necessary file of a module that is on is missing. The file can
  be the development environment skill. It can be `scripts/build-agent.sh` and
  `docs/agents/build.md`, plus `scripts/formatter-agent.sh` and
  `docs/agents/format-validator.md` when a formatter is configured. These
  scripts must be executable. It can be the symlinks of the platforms in
  `modules.agent_platforms` (agent links only when `docs/agents/` is there). It
  can be `CLAUDE.md` with `@AGENTS.md` when `claude` is in the list. Also FAIL:
  a symlink is broken.
- **Agent links:** The standard `.agents/skills` symlink is missing, or it is
  broken, or it is a directory and not a symlink.
- **Copyright:** The `copyright` module is on, and a source, script, or config
  file has no `Copyright` line in its first 5 lines. The check does not look at
  Markdown, JSON, `.gitignore`, `.python-version`, and `.agent-scaffolding.yml`
  files.
- **Build (`--with-build`):** A build or formatter script is not correct. The
  log stays in a file for a short time, and the output shows its path.
- **Git:** The target is not a repository.
- **CHANGELOG:** `CHANGELOG.md` is missing, or it has no `## [Unreleased]`
  section.

WARN results (they do not cause a failure):

- `# TODO:` lines with no content in the scripts
- A SKILL.md with 500 lines or more
- A dirty working tree
- Template comments (`<!-- ... -->`) that stay in `README.md`, `AGENTS.md`, or
  `docs/*.md`. The category markers `<!-- [CAT] ... -->` and `<!-- [DOC] ...
  -->` are permitted.
- Commits made after the skill added `.agent-scaffolding.yml` that have no
  `Assisted-by:` footer

These checks do not look at the paths in `exclude_paths` in
`.agent-scaffolding.yml`: template text, links, home paths, and copyright
headers.

The script prints `VERIFY: N passed, M warnings, K failed` at the end. The exit
code is not 0 when K > 0.

## Manual check

The script cannot check these items. Confirm these items, and write what you
find into the report at the end:

- [ ] Each commit obeys the commit mode: `--no-gpg-sign` in AUTONOMOUS mode, a
  stop in HITL mode. Each commit has the identity inline and the `Assisted-by:`
  footer.
- [ ] DRY: no commands with many steps in files that are not skill files
  (README.md can have single commands)
- [ ] The skills do not share parts (no pair shares more than 30 percent of its
  instructions), and each configured tool has a skill
- [ ] `docs/ARCHITECTURE.md` gives the current architecture, and it has no
  decisions
- [ ] The decisions about the development environment, the modules, and each
  tool deviation are in ADRs
- [ ] The skill verified the tool configs against the installed tool versions
  (or in the container)
- [ ] The development environment operates (the venv is there, or the image is
  built and the smoke test is correct)
- [ ] The build, the tests, and the format check are correct (if they are
  configured)
- [ ] Apply mode only: the skill did not overwrite a file without approval, and
  it kept the content of the user
