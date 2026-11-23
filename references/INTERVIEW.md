# Interview and Configuration

Find the values for the project in two steps. Find them first from the files.
Then put your questions to the user. Write the result to
`.agent-scaffolding.yml` at the root of the target project. All subsequent steps
read this file.

## 1. Find the values (read-only)

Run `scripts/audit.sh <target-dir>` from this skill directory. Then examine the
target. Fill in each answer that you can find before the interview:

- **Mode:** See the mode section in [SKILL.md](../SKILL.md#1-select-the-mode).
  `.agent-scaffolding.yml` is in the target → **apply (run it again)**.
- **Name:** `package.json` `name`, `pyproject.toml` `[project] name`,
  `Cargo.toml` `[package] name`, `CMakeLists.txt` `project()`, `go.mod` module,
  or the directory name.
- **Description:** The description in the manifest, or the first paragraph of
  `README.md`.
- **Type:** Source files or a build manifest are in the target → `software`.
  Only `.md`, `.mdx`, or `.rst` files → `documentation`. The two together →
  `mixed`.
- **Languages:** File extensions and manifests
  (`pyproject.toml`/`requirements.txt` → Python, `package.json` → JS/TS,
  `Cargo.toml` → Rust, `CMakeLists.txt` → C/C++, `go.mod` → Go).
- **Build system:** `CMakeLists.txt`, `Makefile`, `pyproject.toml`
  `[build-system]`, `package.json` with a `build` script, `Cargo.toml`,
  `build.gradle*`, `go.mod`. A manifest that has only dependencies (for example
  `requirements.txt`) is not a build system.
- **Test framework:** The content of `tests/`, dev dependencies (`pytest`,
  `jest`, `vitest`, `gtest`), `[dev-dependencies]`.
- **Linter / formatter:** Config files: `.clang-tidy`, `.clang-format`,
  `ruff.toml`, `[tool.ruff]`, `[tool.black]`, `.eslintrc*`, `eslint.config.*`,
  `.prettierrc*`, `rustfmt.toml`.
- **Dev environment:** `docker-compose.yml`/`compose.yaml`/`Dockerfile` → an
  environment in a container (`containerized`). `.venv/` or `.python-version` →
  an environment on the host (`native`).
- **License / copyright:** `LICENSE*` file: record the file name, the full name
  of the license (for example `MIT License`), and the copyright line with its
  year. The line in the license file always wins. It is stronger than a line
  that the interview answers give.
- **Agent platforms:** The directories `.github/`, `.claude/`, `.pi/`, or
  `.opencode/` are in the target.

## 2. Get the missing answers

Show the values that you found, and let the user confirm or correct them. Use
the question tool of the platform if the platform has one. Put questions in
batches of connected questions, not one question at a time. Necessary answers:

1. **Project:** name, one-line description, type (`software`, `documentation`,
   or `mixed`), languages and versions, target platforms
2. **Operations:** commit mode (`autonomous` or `hitl`. Default: `autonomous`),
   build system, test framework, linter, formatter, build convention, dev
   environment (`auto`, `native`, `containerized`, or `none`)
   - **Build convention:** `out-of-source` for languages that you compile with a
     build directory that is not in the source tree (CMake, Gradle). `in-source`
     for tools that build into the source tree (Make, Cargo `target/`, npm
     `dist/`). `none` for languages with no build step and for documentation.
   - **Dev tools:** pin the versions of the linter, the formatter, and the test
     framework in the development environment. For example, use a `dev`
     dependency group in `pyproject.toml`. Then all contributors and agents run
     the same versions.
3. **Identity:** git author name and email, copyright holder and email (default:
   the git author), license (default: keep the existing license. If there is
   none, put a question to the user)
4. **Modules:** which optional modules to turn on (the defaults are below)
5. **Pre-existing documents:** files to import, and the rule for each
   (`immutable`, `append-only`, or `editable`)
6. **Specs in the skill:** which of COMMITS, semver, and SKILLS to copy into the
   project (default: all three)
7. **Excluded paths (apply mode only):** directories that `verify.sh` must not
   examine, for example vendored code or template sources that contain
   placeholders on purpose. The skill keeps them in `exclude_paths` (default:
   none).

## 3. Module defaults

- **`dev_environment`**
  ([modules/dev-environment.md](modules/dev-environment.md)): on by default when
  `type` is `software` or `mixed`.
- **`build_agents`** ([modules/build-agents.md](modules/build-agents.md)): on by
  default when `operations.build_system`, `operations.test_framework`, or
  `operations.formatter` is not `none`.
- **`tool_configs`** ([modules/tool-configs.md](modules/tool-configs.md)): on by
  default when a linter or a formatter is configured.
- **`boilerplate`** ([modules/boilerplate.md](modules/boilerplate.md)): on by
  default in bootstrap mode when `type` is `software` or `mixed` and the target
  has no source files.
- **`copyright`** ([modules/copyright.md](modules/copyright.md)): on by default
  when a license is configured and `type` is `software` or `mixed` (default OFF
  for `documentation`).
- **`agent_platforms`**
  ([modules/agent-platforms.md](modules/agent-platforms.md)): always on (the
  default list is empty. Put a platform into the list only when the user wants
  the links of that platform).

## 4. Write `.agent-scaffolding.yml`

Copy [assets/repo/agent-scaffolding.yml](../assets/repo/agent-scaffolding.yml)
to `<target>/.agent-scaffolding.yml`, and put the values into it. In bootstrap
mode, write it in Phase 1 (after `git init`). In apply mode, write it with the
first change that has user approval. Commit this file. It records the decisions
and the version of the skill that the project applied. Do not keep the agent
name or the model in it, because they change between sessions.

## Placeholders

Use these values for the `{{...}}` markers in [assets/repo/](../assets/repo/):

- **`{{PROJECT_NAME}}`:** `project.name`
- **`{{PROJECT_DESCRIPTION}}`:** `project.description`
- **`{{PROJECT_TYPE}}`:** `project.type`
- **`{{LANGUAGES}}`:** `project.languages`, with commas between, or `None`
- **`{{LICENSE_NAME}}`:** `project.license`, the full name (for example `MIT
  License`)
- **`{{LICENSE_FILE}}`:** `project.license_file` (for example `LICENSE.md`)
- **`{{COPYRIGHT_LINE}}`:** The copyright line from the license file. If the
  file has no line, the skill makes it from the answers, for example `Copyright
  (c) 2026 Jane Doe <jane@example.com>`.
- **`{{COMMIT_MODE}}`:** `AUTONOMOUS` or `HITL`
- **`{{DATE}}`:** Today in ISO format (`YYYY-MM-DD`)
- **`{{SKILL_VERSION}}`:** `metadata.version` from the `SKILL.md` of this skill
- **`{{BUILD_COMMAND}}` / `{{TEST_COMMAND}}`:** Single commands for the
  configured toolchain. Remove the line when the tool is not configured. Remove
  the full `## Commands` section when the project has no build command and no
  test command.
- **`{{DEV_ENV_COMMAND}}`:** One command to prepare or enter the development
  environment, for example `scripts/enter-dev.sh` (containerized) or `python3 -m
  venv .venv` (native).
- **`{{SKILL_INDEX}}`:** A markdown list with links to all generated
  `docs/skills/*/SKILL.md`
