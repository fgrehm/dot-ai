# Roadmap

## Phase 1: Claude Code ✅

1. Copy existing `CLAUDE.md` and `skills/` into repo
2. Write `install.sh` and `uninstall.sh`
3. Verify symlinks work with Claude Code

## Phase 2: Web chat configs ✅

1. Add `web/` directory for Claude.ai and ChatGPT personal instructions
2. Document the manual copy-paste workflow in README

## Phase 3: pi-coding-agent + shared skills ✅

1. Move skills to shared `~/.agents/skills/` location
2. Share `claude/CLAUDE.md` as `~/.pi/agent/AGENTS.md`
3. Extend install/uninstall scripts for both tools
4. Document symlink layout in README

## Ideas

- Add more web chat providers as needed (Gemini, Copilot, etc.)
- Script to diff local files against what's pasted in web UIs (probably not feasible, but worth thinking about)
