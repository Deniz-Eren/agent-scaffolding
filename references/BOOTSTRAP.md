# Bootstrap Workflow (new project)

Use this workflow when the target directory is empty or has no git repository.
This is necessary before you start:

- The interview is finished ([INTERVIEW.md](INTERVIEW.md)). Phase 1 writes the
  answers to `.agent-scaffolding.yml`.
- You have read [RULES.md](RULES.md).

Do the phases in this sequence. At the end of each phase, make **one atomic
commit** that obeys the git protocol ([RULES.md §5](RULES.md#5-git-protocol)).
In HITL mode, stop before each commit.

`$SKILL` in this document is the directory of this skill. It is the directory
that contains `SKILL.md`.

## Phase 1: Initialize and import

1. Run `git init -b main` (only when `.git/` is not there).
2. Copy `$SKILL/assets/repo/gitignore` to `.gitignore`. Keep only the sections
   for the languages of the project. Do not ignore `src/`, `include/`, or
   `tests/`.
3. Import the pre-existing documents ([RULES.md
   §12](RULES.md#12-pre-existing-documents)). If a license file is there, write
   its copyright line from the file. If there is no license file and the user
   selected a license, make the license file with the full license text and the
   copyright line.
4. Copy the specs in the skill that are on, with no changes (policy:
   `immutable`):
   - **Conventional Commits:** `$SKILL/references/specs/COMMITS.md` →
     `docs/skills/git/references/COMMITS.md`
   - **Semantic Versioning:** `$SKILL/references/specs/semver.md` →
     `docs/skills/git/references/semver.md`
   - **Agent Skills:** `$SKILL/references/specs/SKILLS.mdx` →
     `docs/skills/create-skill/references/SKILLS.mdx`

5. Write `.agent-scaffolding.yml` from the interview answers. This is the only
   time that you write it during bootstrap. Subsequent phases only read it.
6. Commit: `chore: start repository and import documents`.

**Copyright (module `copyright`):** from this phase on, add the header to each
file when you make it ([modules/copyright.md](modules/copyright.md)). Do not add
the headers in one step at the end.

**Commit types:** the commit messages in this workflow are examples. Use the
Conventional Commits type that is correct for the project and the change (for
example `docs:` for a documentation project, `build:` for build files).

## Phase 2: State documents

1. Make `docs/TASKS.md`, `docs/VISION.md`, `docs/DECISIONS.md`, and
   `docs/THIRD-PARTY-NOTICES.md` from `$SKILL/assets/repo/docs/`, and
   `CHANGELOG.md` from `$SKILL/assets/repo/CHANGELOG.md`.
2. For each spec that you copied, add its entry from
   `$SKILL/references/SPEC-NOTICES.md` to Section 1 of THIRD-PARTY-NOTICES, and
   remove the template comment.
3. ADR-1 in the template records the adoption and the commit mode. Add ADRs for
   the other first decisions: the project type, the selected modules, and the
   type of the development environment (if that module is on).
4. Write VISION.md (Mission, Guiding Principles, and Target Result) from the
   interview answers. Remove the template comments.
5. Commit: `docs: add state documents`.

## Phase 3: Governance, skills, and tools

1. Make `AGENTS.md` from the template. Remove the Failure Modes rows for builds
   and tests when the project has no build system or no tests.
2. Make `docs/CONVENTIONS.md` from the template.
3. Make `docs/skills/create-skill/`, `docs/skills/git/`,
   `docs/skills/state-management/`, and `docs/skills/keepachangelog/` from the
   templates.
4. **Module `dev_environment`:** generate the environment files, make the
   environment, and run its smoke test
   ([modules/dev-environment.md](modules/dev-environment.md)). Then make
   `docs/skills/dev-environment/SKILL.md` with the commands that the project
   uses. Do this **before** the tool configs, so that the tools run in the
   environment.
5. If a build system is configured, make the build file or files at the root.
6. **Module `tool_configs`:** make sure of the tool versions **in the
   development environment**. Then generate small configs, and verify them
   ([modules/tool-configs.md](modules/tool-configs.md)).
7. Make one skill for each configured tool (build system, test framework,
   linter, formatter). Use the `create-skill` procedure, and obey [RULES.md
   §11](RULES.md#11-rules-for-skills).
8. Commit: `chore: add governance, skills and tool configuration`.

## Phase 4: Boilerplate

Skip this phase if the `boilerplate` module is off.

1. Make the code skeleton ([modules/boilerplate.md](modules/boilerplate.md)).
2. Commit: `feat: add project skeleton`.

## Phase 5: Agents, integration and finalization

1. **Module `build_agents`:** make the scripts and `docs/agents/*.md`
   ([modules/build-agents.md](modules/build-agents.md)). From this point,
   delegate all build, test, and format runs to these agents.
2. Run the build, the tests, and the format check (through the build agents, if
   they are on). Repair the problems until all results are correct ([RULES.md
   §13](RULES.md#13-build-integrity)).
3. Make the standard agent link: `mkdir -p .agents && ln -sfn ../docs/skills
   .agents/skills` ([RULES.md §6](RULES.md#6-root-files)).
4. **Module `agent_platforms`:** make the links for the platforms in the
   configuration ([modules/agent-platforms.md](modules/agent-platforms.md)).
5. Make `README.md` from the template, and put all the skills that you made into
   `{{SKILL_INDEX}}`.
6. Make `docs/ARCHITECTURE.md` from the template, with the directory tree and
   components of the project.
7. **Module `copyright`:** confirm that all files that must have a header have
   one.
8. Mark the bootstrap tasks `[x] COMPLETE YYYY-MM-DD` in TASKS.md. Complete the
   scaffolding entry that the template has in `CHANGELOG.md`. Do not add a
   second entry.
9. Run `$SKILL/scripts/verify.sh .` ([VERIFICATION.md](VERIFICATION.md)), and
   repair all `FAIL` and `WARN` results.
10. Commit: `chore: add agents and finalize scaffolding`.

## Report

End with a summary that contains:

- The files that the skill made, in groups by phase
- The modules that are on
- The output of `verify.sh`
- The ADRs that it recorded
- The next steps that you recommend, for example "push after review" or
  "complete the Target Result section in VISION.md"
