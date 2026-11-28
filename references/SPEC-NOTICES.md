# Notices for the Specifications in the Skill

These are the summary attribution entries for the specifications in
[specs/](specs/). When you copy a spec into a target project, also copy its
entry into Section 1 of the `docs/THIRD-PARTY-NOTICES.md` of the target. Do not
copy full license text blocks into `docs/THIRD-PARTY-NOTICES.md`.

When you copy an entry, change the `Component(s) Used` line to a relative link
from `docs/` to the copied file. Copy the remaining part of the entry with no
changes. Example for COMMITS.md:

```markdown
* **Component(s) Used:** [skills/git/references/COMMITS.md](skills/git/references/COMMITS.md)
```

| Spec | Destination in the target project |
|---|---|
| COMMITS.md | `docs/skills/git/references/COMMITS.md` |
| SKILLS.mdx | `docs/skills/create-skill/references/SKILLS.mdx` |
| semver.md | `docs/skills/git/references/semver.md` |

---

### conventionalcommits.org
* **Component(s) Used:** link to `docs/skills/git/references/COMMITS.md` (see above)
* **Source:** [conventionalcommits.org (v1.0.0)](https://github.com/conventional-commits/conventionalcommits.org/blob/master/content/v1.0.0/index.md)
* **Source License:** MIT License (`MIT`, Copyright (c) 2018 Conventional
  Changelog). The full license text is in the conventionalcommits.org repository
  at the source link above.

### agentskills
* **Component(s) Used:** link to `docs/skills/create-skill/references/SKILLS.mdx` (see above)
* **Source:** [github.com/agentskills/agentskills](https://github.com/agentskills/agentskills/blob/main/docs/specification.mdx)
* **Source License:** Apache License 2.0 (`Apache-2.0`, Copyright 2025
  Anthropic, PBC). The full license text is in the agentskills repository at the
  source link above.

### Semantic Versioning 2.0.0
* **Component(s) Used:** link to `docs/skills/git/references/semver.md` (see above)
* **Source:** [github.com/semver/semver.md](https://github.com/semver/semver/blob/master/semver.md)
* **Source License:** Creative Commons Attribution 3.0 Unported (`CC-BY-3.0`).
  The full license text is at
  [creativecommons.org/licenses/by/3.0](https://creativecommons.org/licenses/by/3.0/legalcode).
