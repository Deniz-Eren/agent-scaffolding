# Module: Copyright Headers

This module puts a copyright header on all files that can hold comments, and
makes `docs/CONVENTIONS.md` with the header formats. The configuration turns on
this module with `modules.copyright`.

## Source of the copyright line

- If a `LICENSE*` file is there or is imported, get its copyright line from it.
  Tell the user which line you got, and use it as `{{COPYRIGHT_LINE}}`.
- If there is no file of this type, make the line as `Copyright (c) <year>
  <holder> <<email>>` from the interview answers.

## Where headers go

- **C, C++, Rust, Go, JS, TS, Java, C#, Swift, Kotlin:** `// {{COPYRIGHT_LINE}}`
- **Python, shell, Ruby, Perl, R:** `# {{COPYRIGHT_LINE}}` (after the shebang
  line)
- **`CMakeLists.txt`, `Makefile`, `Dockerfile`, `docker-compose.yml`:** prefix
  with `# {{COPYRIGHT_LINE}}`
- **YAML, TOML, INI, `.clang-format`, `.clang-tidy`, `.editorconfig`:** prefix
  with `# {{COPYRIGHT_LINE}}`
- **HTML, XML:** `<!-- {{COPYRIGHT_LINE}} -->`
- **CSS, SCSS:** `/* {{COPYRIGHT_LINE}} */`

You can add an SPDX line below the copyright line, for example
`SPDX-License-Identifier: MIT`. Record this decision in an ADR.

## Files with no header

- Markdown (`.md`, `.mdx`)
- `.gitignore`
- License files
- Pre-existing documents that are immutable or append-only
- JSON files (`package.json` and files like it), because JSON has no comments
- Files that a tool reads as plain data and that cannot hold comments, for
  example `.python-version`
- `.agent-scaffolding.yml`
- Paths in `exclude_paths`

## CONVENTIONS.md

The `docs/CONVENTIONS.md` template
([assets/repo/docs/CONVENTIONS.md](../../assets/repo/docs/CONVENTIONS.md))
contains a module block with the header table. Put only the file types that the
project uses into it.

## Apply mode

Add headers to files that are there only with user approval. Give the files that
have no header in the gap report. This includes configuration files that the
user owns (for example `pyproject.toml` or `package.json` scripts). They get a
header only with the approval of the user.
