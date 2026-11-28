# Third-Party Notices

## Purpose

Record the third-party open-source software, files, snippets, and libraries that
agent-scaffolding uses. Give the license attribution and the compliance notices.

## Structure

Two numbered sections group the entries. Section 1 lists copied files and
snippets in the repository. Section 2 lists external dependencies and build
tools. Each entry gives a short summary with the source, the license type, and
the function or file path of the component.

## Formatting Rules

- Do not copy full license text blocks into this document. Write a short summary
  of the license type. Give the license name or SPDX identifier, the copyright
  holder, and a link to the license text or upstream repository.
- In Section 1 (copied files and snippets), record `Component(s) Used`,
  `Source`, and `Source License` as a short summary.
- In Section 2 (dependencies and build tools), record `Function`, `Source`, and
  `License` as a short summary.
- Do not erase entries. Add an entry when you add a third-party component, and
  keep source URLs accurate.

---

This document records the third-party open-source software, files, snippets, and
libraries that this project uses. We give thanks to the open-source community
for its work.

The notices, terms, and links below give the attribution for their open-source
licenses. **Note:** these licenses apply only to the third-party files and
dependencies in this document. They do not change the primary license of this
project. The primary license is in [LICENSE.md](../LICENSE.md).

## 1. Copied Files and Snippets

### conventionalcommits.org
* **Component(s) Used:** [references/specs/COMMITS.md](../references/specs/COMMITS.md),
  [docs/skills/git/references/COMMITS.md](skills/git/references/COMMITS.md)
* **Source:** [conventionalcommits.org (v1.0.0)](https://github.com/conventional-commits/conventionalcommits.org/blob/master/content/v1.0.0/index.md)
* **Source License:** MIT License (`MIT`, Copyright (c) 2018 Conventional
  Changelog). The full license text is in the conventionalcommits.org repository
  at the source link above.

### agentskills
* **Component(s) Used:** [references/specs/SKILLS.mdx](../references/specs/SKILLS.mdx),
  [docs/skills/create-skill/references/SKILLS.mdx](skills/create-skill/references/SKILLS.mdx)
* **Source:** [github.com/agentskills/agentskills](https://github.com/agentskills/agentskills/blob/main/docs/specification.mdx)
* **Source License:** Apache License 2.0 (`Apache-2.0`, Copyright 2025
  Anthropic, PBC). The full license text is in the agentskills repository at the
  source link above.

### Semantic Versioning 2.0.0
* **Component(s) Used:** [references/specs/semver.md](../references/specs/semver.md),
  [docs/skills/git/references/semver.md](skills/git/references/semver.md)
* **Source:** [github.com/semver/semver.md](https://github.com/semver/semver.md/blob/master/semver.md)
* **Source License:** Creative Commons Attribution 3.0 Unported (`CC-BY-3.0`).
  The full license text is at
  [creativecommons.org/licenses/by/3.0](https://creativecommons.org/licenses/by/3.0/legalcode).

### keepachangelog.com
* **Component(s) Used:** [skills/keepachangelog/SKILL.md](skills/keepachangelog/SKILL.md)
* **Source:** [keepachangelog.com](https://keepachangelog.com)
* **Note:** The keepachangelog skill gives the Keep a Changelog format with its
  own words. No text is copied from the source.

## 2. Dependencies and Build Tools

No external runtime dependencies or third-party libraries are included in this
repository.
