# Roadmap

## Phase 1: Claude Code ✅

1. Copy existing `CLAUDE.md` and `skills/` into repo
2. Write `install.sh` and `uninstall.sh`
3. Verify symlinks work with Claude Code

## Phase 2: Web chat configs ✅

1. Add `web/` directory for Claude.ai and ChatGPT personal instructions
2. Document the manual copy-paste workflow in README

## Phase 3: pi-coding-agent

1. Add `pi/` directory with config files
2. Extend install/uninstall scripts to handle `~/.pi/agent/`
3. Document pi-specific config in README

## Phase 4: Shared config

1. Identify shared instructions between Claude and pi (both read `AGENTS.md`/`CLAUDE.md`)
2. Factor out common instructions if duplication becomes a problem

## Ideas

- Add more web chat providers as needed (Gemini, Copilot, etc.)
- Script to diff local files against what's pasted in web UIs (probably not feasible, but worth thinking about)
