---
name: dev-environment
description: Set up, enter and use the isolated development environment of {{PROJECT_NAME}}. Use before you build, test, lint or format, when you add dependencies, or when environment problems occur.
---

# Development Environment

**Type:** <!-- Native (Python venv) | Containerized (Podman Compose) | None -->

## Setup

<!-- Native example:
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
-->
<!-- Containerized example:
podman compose build dev
-->

## Use

<!-- How to run the build, test, lint and format tools inside the environment.
     Native: source .venv/bin/activate && <tool>
     Containerized: podman compose run --rm dev <tool>, or scripts/enter-dev.sh for an interactive shell -->

## Dependencies

<!-- How to add a dependency, and the file that declares it (requirements.txt, pyproject.toml, Dockerfile, ...).
     After you add one: make a new build or install again, and record it in docs/THIRD-PARTY-NOTICES.md. -->

## Troubleshooting

| Symptom | Correction |
|---|---|
| <!-- for example "command not found" in the container --> | <!-- add the tool to the Dockerfile and make a new build --> |
