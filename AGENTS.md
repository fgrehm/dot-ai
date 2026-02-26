# dot-ai

Dotfiles repo for AI coding tool configurations. Symlink-based, no dependencies.

## Structure

- `claude/` - Claude Code global config (`CLAUDE.md`)
- `pi/` - pi global config (`AGENTS.md`)
- `skills/` - Shared skills for all coding agents (symlinked to `~/.agents/skills/`)
- `web/` - Web chat interface configs (Claude.ai, ChatGPT) — manual copy-paste, not symlinked
- `install.sh` / `uninstall.sh` - Symlink management scripts

## How syncing works

`install.sh` symlinks files from this repo into `~/.claude/` (and eventually `~/.pi/agent/`). It backs up existing files before replacing them. `uninstall.sh` reverses the process.

## Conventions

- Plain files and directories only, no build tools or package managers
- Shell scripts should be POSIX-compatible where practical
- Keep configs minimal and well-commented
