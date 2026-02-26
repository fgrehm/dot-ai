# dot-ai

Configuration files for AI coding tools, managed with symlinks.

## What's in here

```
dot-ai/
├── claude/
│   ├── CLAUDE.md          # Global instructions for Claude Code
│   ├── settings.json      # Permissions, model, telemetry, etc.
│   └── output-styles/     # Custom output styles (Navigator v1/v2)
├── pi/
│   └── AGENTS.md          # Global instructions for pi
├── skills/                # Shared skills (symlinked to ~/.agents/skills/)
├── web/
│   ├── claude-ai/
│   │   ├── personal-instructions.md
│   │   └── projects/      # Claude.ai project configs (description + instructions)
│   └── chatgpt/           # ChatGPT custom instructions
├── install.sh             # Symlink everything into place
└── uninstall.sh           # Remove symlinks
```

## Supported tools

| Tool | Config location | Status |
|------|----------------|--------|
| [Claude Code](https://claude.ai/claude-code) | `~/.claude/` | Active |
| [pi-coding-agent](https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent) | `~/.pi/agent/` | Active |
| [Claude.ai](https://claude.ai) | `web/claude-ai/` (manual copy-paste) | Active |
| [ChatGPT](https://chatgpt.com) | `web/chatgpt/` (manual copy-paste) | Active |

## Setup

```sh
git clone <repo-url> ~/projects/oss/dot-ai
cd ~/projects/oss/dot-ai
./install.sh
```

To remove all symlinks:

```sh
./uninstall.sh
```

## How it works

`install.sh` creates symlinks from this repo to where each tool expects its config. Existing files are backed up with a `.bak` suffix before being replaced.

No frameworks, no dependencies, just symlinks.

### Symlink layout

```
~/.agents/skills/        -> skills/              # Shared skills (standard location)
~/.claude/CLAUDE.md      -> claude/CLAUDE.md     # Global instructions for Claude Code
~/.claude/settings.json  -> claude/settings.json # Permissions, model, telemetry
~/.claude/output-styles/ -> claude/output-styles/ # Custom output styles
~/.claude/skills/        -> skills/              # Claude Code skill discovery
~/.pi/agent/AGENTS.md   -> pi/AGENTS.md          # Global instructions for pi
~/.pi/agent/skills/      -> skills/              # pi skill discovery
```

### Web chat configs (`web/`)

Files under `web/` are **not** symlinked — they're reference copies you paste into each web UI's settings manually. The `<!-- Last synced -->` comment at the top of each file helps track when you last updated the live version.

## Ideas

- Rename `claude-project-sync` skill to something tool-agnostic (e.g. `web-project-sync`)
- Drift detection script to diff `claude/CLAUDE.md` vs `pi/AGENTS.md`
- `install.sh --dry-run` flag to preview symlinks without creating them
- More web chat providers as needed (Gemini, Copilot, etc.)
