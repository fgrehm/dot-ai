---
name: link-memory
description: >
  Symlink an AI coding tool's auto-memory file into the project root so it's
  visible during development. Use when the user asks to "link memory", "show
  memory in project", "symlink memory", "make memory visible", or wants to
  access their AI tool's persistent memory from the project tree. Currently
  supports Claude Code's MEMORY.md.
---

# Link Memory

Symlink an AI tool's auto-memory into `.ai/memory.md` at the project root.
The symlink is added to `.git/info/exclude` so it stays local.

## How to use

Run the bundled script:

```bash
bash <skill-dir>/scripts/link-memory.sh [project-dir]
```

Where `<skill-dir>` is the directory containing this SKILL.md. If `project-dir`
is omitted, the script uses the git repo root (or `$PWD` as fallback).

## Supported tools

| Tool        | Memory location                                              |
|-------------|--------------------------------------------------------------|
| Claude Code | `~/.claude/projects/<mangled-path>/memory/MEMORY.md`         |

The mangled path is the project's absolute path with `/` and `.` both
replaced by `-` (e.g., `/home/user/.config/myproject` becomes
`-home-user--config-myproject`).

## When the memory file doesn't exist

The tool must have created a memory file before this skill can link it. If the
file doesn't exist yet, inform the user and suggest they first use the tool in
the project so it creates one.

## Adding support for other tools

To add a new tool, edit `scripts/link-memory.sh` and add a detection block
before the "No memory file found" error. The first tool that has a memory file
wins.
