# Module: Development Environment

All software projects get an isolated development environment. It operates the
same each time. The configuration turns on this module with
`modules.dev_environment`.

## Resolve the environment type

Value of `operations.dev_environment`:

- **`native`:** Native.
- **`containerized`:** Containerized (Podman Compose, or Docker Compose).
- **`none`:** No environment files. The development environment skill records
  that no setup is necessary.
- **`auto` (default):** Python only → **Native**. One other language, or more
  than one language → **Containerized**. Only documents → **none**.

Record the type that you selected and the cause in an ADR in
`docs/DECISIONS.md`.

## Files to generate

- **Native (Python):** `.python-version`, `requirements.txt` (or
  `pyproject.toml` dependencies), and `.venv/` in `.gitignore`.
- **Containerized:** `docker-compose.yml` with a `dev` service, a `Dockerfile`
  that installs each configured tool (compilers, build system, test framework,
  linter, formatter), and an executable `scripts/enter-dev.sh` (template:
  [enter-dev.sh](../../assets/repo/scripts/enter-dev.sh)).

- Use a base image that is correct for the languages, for example `ubuntu:24.04`
  with toolchains for C/C++, or `python:3.12-slim`.
- Mount the project at one path (for example `/workspace`), and set
  `working_dir` to that path.
- Add the build and cache directories of the environment to `.gitignore`.

## Commands

- Native: `source .venv/bin/activate && <tool>`
- Containerized: `podman compose run --rm dev <tool>`

The build and formatter scripts (module `build_agents`) must operate the same.

## Documentation

- Generate `docs/skills/dev-environment/SKILL.md` from
  [dev-environment/SKILL.md](../../assets/repo/skills/dev-environment/SKILL.md).
  It gives the setup, the start of the environment, and the installation of the
  dependencies. It also gives the operation of the tools in the environment and
  a new build of the image. A section helps to find the cause of a problem.
- `README.md` gets a `## Development Environment` section with the single setup
  command (`{{DEV_ENV_COMMAND}}`).

## Verification

- **Native:** make the venv, install the dependencies, then run a smoke test
  (for example `python -c "import <package>"`).
- **Containerized:** run `podman compose build dev`, then run a smoke test with
  `podman compose run --rm dev <tool> --version` for each tool in the
  configuration. Verify the tool configs in the container (see
  [tool-configs.md](tool-configs.md)).
- If podman and docker are not installed, do not stop. Record this in
  `docs/DECISIONS.md`, tell the user, and continue with the checks on the host
  that are possible.
