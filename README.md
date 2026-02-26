# dot-ai

Configuration files for AI coding tools, managed with symlinks.

## What's in here

```
dot-ai/
├── claude/
│   ├── CLAUDE.md          # Global instructions for Claude Code
│   └── skills/            # Reusable skills (project-inception, etc.)
├── web/
│   ├── claude-ai/
│   │   ├── personal-instructions.md
│   │   └── projects/      # Claude.ai project configs (description + instructions)
│   └── chatgpt/           # ChatGPT custom instructions
├── pi/                    # (future) pi-coding-agent config
├── install.sh             # Symlink everything into place
└── uninstall.sh           # Remove symlinks
```

## Supported tools

| Tool | Config location | Status |
|------|----------------|--------|
| [Claude Code](https://claude.ai/claude-code) | `~/.claude/` | Active |
| [Claude.ai](https://claude.ai) | `web/claude-ai/` (manual copy-paste) | Active |
| [ChatGPT](https://chatgpt.com) | `web/chatgpt/` (manual copy-paste) | Active |
| [pi-coding-agent](https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent) | `~/.pi/agent/` | Planned |

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

### Web chat configs (`web/`)

Files under `web/` are **not** symlinked — they're reference copies you paste into each web UI's settings manually. The `<!-- Last synced -->` comment at the top of each file helps track when you last updated the live version.
