# dot-ai

Dotfiles repo for AI coding tool configurations. Symlink-based, no dependencies.

## Philosophy

Use AI with intention. Speed and convenience are easy defaults, but the goal is tools that make the human better, not just faster.

- **Clarify before acting.** A vague request answered quickly costs more total time than a brief clarification up front.
- **Explicit over implicit.** Skills declare what they do. Configs are plain files you can read and grep. No opaque state.
- **Cheap where cheap works, smart where smart matters.** Not everything needs an LLM. Deterministic tools (regex, shell, keyword matching) should handle what they can. Reserve model calls for genuinely ambiguous or generative work.

## Structure

- `claude/` - Claude Code global config (`CLAUDE.md`, `settings.json`, `output-styles/`)
- `pi/` - pi global config (`AGENTS.md`)
- `skills/` - Shared skills for all coding agents (symlinked per-tool into `~/.claude/skills/`, `~/.pi/agent/skills/`)
- `web/` - Web chat interface configs (Claude.ai, ChatGPT), manual copy-paste, not symlinked
- `install.sh` / `uninstall.sh` - Symlink management scripts

## How syncing works

`install.sh` symlinks files from this repo into `~/.claude/` and `~/.pi/agent/`. It backs up existing files before replacing them. `uninstall.sh` reverses the process.

## Vendored skills

Third-party skills are vendored with `vendor-skill.sh`. Each vendored skill's `README.md` has a `Source:` line at the top pointing to the exact commit it came from.

When modifying a vendored skill, document the changes in its `README.md` under a `## Local changes` section so the delta from upstream is clear.

## GitHub interactions

**NEVER comment on GitHub on behalf of the user.** Do not post issue comments, PR reviews, replies, or any GitHub interactions. Opening draft pull requests is OK. For everything else, always ask first. No exceptions.

## Conventions

- Plain files and directories only, no build tools or package managers
- Shell scripts should be POSIX-compatible where practical
- Keep configs minimal and well-commented
- Include a URL when referencing any tool, library, article, or documentation
- Do not hard-wrap lines in SKILL.md files (including YAML frontmatter). These are read by models, not displayed in fixed-width terminals

### Skill changes

When a skill is added, modified, or evolved:

- Update its `README.md` (vendored skills: add or update `## Local changes`; original skills: update the description)
- Add a CHANGELOG.md entry describing what changed and why
- If the skill's scope expanded (e.g., new use cases, new references), make that visible in both places

### Inline annotations

These annotations address tasks to AI agents working in the codebase. Agents should surface them and ask how to proceed before acting:

- `TODO(@agent)` - Task to complete. Confirm scope and approach first.
- `FIXME(@agent)` - Issue to investigate. Present findings and proposed fix before changing code.
- `DISCUSS(@agent)` - Topic to raise. Start a discussion, do not take action.
- `REVIEW(@agent)` - Code or text to review. Share observations and suggestions.

Annotations addressed to specific people (e.g., `TODO(@fabio)`) or bare `TODO` / `FIXME` without `@agent` are human notes, not agent instructions.
