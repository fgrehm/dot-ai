# dot-ai

Dotfiles repo for AI coding tool configurations. Symlink-based, no dependencies.

## Structure

- `claude/` - Claude Code global config (`CLAUDE.md`, `settings.json`, `output-styles/`)
- `pi/` - pi global config (`AGENTS.md`)
- `skills/` - Shared skills for all coding agents (symlinked to `~/.agents/skills/`)
- `web/` - Web chat interface configs (Claude.ai, ChatGPT) — manual copy-paste, not symlinked
- `install.sh` / `uninstall.sh` - Symlink management scripts

## How syncing works

`install.sh` symlinks files from this repo into `~/.claude/` and `~/.pi/agent/`. It backs up existing files before replacing them. `uninstall.sh` reverses the process.

## Vendored skills

Third-party skills are vendored with `vendor-skill.sh`. Each vendored skill's
`README.md` has a `Source:` line at the top pointing to the exact commit it came
from.

When modifying a vendored skill, document the changes in its `README.md` under
a `## Local changes` section so the delta from upstream is clear.

## Conventions

- Plain files and directories only, no build tools or package managers
- Shell scripts should be POSIX-compatible where practical
- Keep configs minimal and well-commented
