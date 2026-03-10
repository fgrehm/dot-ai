# Changelog

Format: date, file(s) changed, what and why. Newest first.

## 2026-03-10

- `skills/technical-spec-writer/SKILL.md` - Reduce code verbosity: specs describe design, not implementation-ready code. Added commit plan subsection to Implementation Order for mapping tasks to atomic, reviewable commits.
- `install.sh` - Switch settings.json from symlink to jq deep merge. Repo base wins for scalar keys, permission arrays (allow, deny, ask) are concatenated and deduplicated, machine-only keys (hooks, plugins) are preserved. Prevents tools and plugins from replacing the symlink and silently losing config. Added `--dry-run` / `-n` flag to preview changes without applying.
- `uninstall.sh` - Skip settings.json on uninstall (merged file, no longer a symlink)

## 2026-03-08

- `claude/CLAUDE.md`, `pi/AGENTS.md`, `skills/end-of-session/SKILL.md` - Standardized memory convention: use `MEMORY.local.md` at project root instead of `.ai/` directory
- `skills/golang-cli-review/` - New vendored skill: code review checklist for Go CLI applications (error handling, Cobra patterns, flag design, I/O, security, testing)
- `claude/CLAUDE.md`, `pi/AGENTS.md` - Removed `AI-Agent` trailer from commit format (unreliable across mid-session model switches)

## 2026-03-07

- `skills/fact-checker/` - New skill: verify factual claims in text before publishing
- `claude/CLAUDE.md` - Added skill awareness section, clarified `.ai/` memory convention
- `pi/AGENTS.md` - Added skill awareness section
- `skills/end-of-session/SKILL.md` - Updated memory section to reference `.ai/` directory, added related skills
- `skills/agentifier/SKILL.md` - Deduplicated "Your Task" and "Process" sections, fixed Liu et al. citation year (2024 -> 2023), removed `version` field, added negative trigger and cross-reference
- `skills/humanizer/SKILL.md` - Scoped voice rules to output text, consolidated inflated language patterns (1+2+4+7 -> 1), renumbered patterns, removed `version` field, added negative trigger and cross-reference
- `skills/golang-pro/SKILL.md` - Removed role-play framing, clarified reference-loading instruction
- `skills/red-green-refactor/SKILL.md` - Made tool-agnostic (removed "Explore agent" reference), added related skills
- `skills/pr-opener/SKILL.md` - Defaulted issue link keyword to safe `Related to #N`
- `skills/project-inception/SKILL.md` - Inlined 5 universal interview questions, added negative trigger
- `skills/technical-spec-writer/SKILL.md` - Added negative trigger, related skills, and user review + final scrutiny pass
- `install.sh` - Removed `~/.agents/skills/` shared symlink (each tool uses its own skills dir)
- `README.md` - Removed `~/.agents/skills` from symlink layout, added Maintenance section
- `CLAUDE.md` (project) - Updated skills path, added no-line-wrap convention for agent-consumed files
- `skills/humanizer/README.md` - Added `## Local changes` section, updated pattern table to match renumbering
- `skills/fact-checker/README.md` - Removed pi.dev and Codex sections, removed DigitalOcean link, used GitHub callout
