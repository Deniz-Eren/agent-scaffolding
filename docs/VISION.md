# Vision

## Purpose

Define the long-term vision and the principles of the agent-scaffolding Agent
Skill.

## Structure

The document has the mission, the principles, and the target result.

## Formatting Rules

- Use short and clear language.
- Look at the vision again and update it when the direction of the project
  changes. Record the change as an ADR in [DECISIONS.md](DECISIONS.md).

## Mission

The mission is to give all AI agents one skill that they can use again. The
skill prepares a project for agents. The project can be new, or it can have
files. The skill contains procedures that gave good results for governance,
state tracking, project skills, isolated environments, and the delegation of
builds to subagents. Then humans and agents can do safe work on the project,
with the same procedures.

## Principles

- **Skill, not prompt:** the skill text is an [Agent
  Skill](https://agentskills.io). Agents load it when it is necessary. The user
  does not configure the skill text by hand.
- **Interview and find:** the agent finds what it can from the project. It puts
  questions to the user only about the remaining values. It records the answers
  in `.agent-scaffolding.yml`. Subsequent runs use the file again.
- **Keep the work of the user safe:** in an existing project, the agent audits
  first. It proposes changes and applies only the changes with user approval. It
  does not overwrite a file without consent.
- **Core plus modules:** a small core always applies. Optional modules add the
  development environment, build agents, tool configs, boilerplate, copyright
  headers, and platform links.
- **All languages and platforms:** the rules apply to all stacks and all agent
  platforms.
- **DRY first:** procedures are only in skill files. All other documents link to
  them.
- **Verification:** `scripts/verify.sh` verifies all rules that a computer can
  verify.
- **Example:** this repository applies its own skill to itself.

## Target Result

An agent with the `agent-scaffolding` skill can make an empty directory or an
existing repository into a project with no FAIL results from `verify.sh`. It
commits each change as an atomic commit, and it records each decision.
