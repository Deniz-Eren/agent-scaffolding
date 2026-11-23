# Module: Tool Configurations

This module generates a config file for each configured linter and formatter,
and verifies the config against the installed version of the tool. The
configuration turns on this module with `modules.tool_configs`.

## Check the version first

1. Find where the tools run:
   - **Native:** make sure on the host with `<tool> --version`, or use `--help`
     for tools that have no version flag.
   - **Containerized:** do not use the host for the check. Generate the configs
     from the tools that the `Dockerfile` names, and verify them in the
     container after the image is built.
2. If the result is `command not found` (exit code 127), do **not** make the
   config. Make the skill, and write in it that the tool must be installed. Then
   record this in an ADR.
3. If the skill can find no version, generate a config with no parameters
   (comments only), and record the uncertainty.

## A small config first

- Start from the default or the preset that the tool knows (for example
  `BasedOnStyle: LLVM` or `extends: recommended`).
- Use the preset. Then add **3 to 5 parameters**, but no more. Count them with
  these rules:
  - The preset is 1 parameter.
  - Each scalar is 1 parameter.
  - A list of checks counts as 1 parameter. The number of checks in it is not
    important.
- Add a parameter only when the cause for it is clear. Record each deviation
  from the defaults in an ADR.

## Loop to verify the config

Only `--version` does not show that the tool accepts the config. Verify it:

1. Run the tool on a small sample. Before the project has source files, use a
   sample in the command, for example `echo 'int x;' | clang-format
   -style=file`.
2. If the tool does not accept the config, remove parameters one at a time until
   the tool accepts it.
3. Add the parameters back one at a time, and verify after each one.
4. Record each parameter that you removed or changed in an ADR.

A config that the tool does not accept counts as a **build failure** (see
[RULES.md §13](../RULES.md#13-build-integrity)). Run the full integration test
after the boilerplate or the source files of the project are there.

## Copyright

If the config format has comments (YAML, TOML, `.clang-format`, `.clang-tidy`,
INI), add the copyright header (see [copyright.md](copyright.md)).
