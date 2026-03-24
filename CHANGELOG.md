# CHANGELOG

Format: date, file(s) changed, what and why. Newest first.

## 2026-03-24

- `claude/CLAUDE.md`, `pi/AGENTS.md` - Added note about confirmation about removing untracked files.

## 2026-03-23

- `claude/CLAUDE.md` - Added explicit GitHub interaction restriction: never comment on GitHub on user's behalf. Draft PRs are OK; all other interactions require explicit user request. No exceptions, somehow that got lost

## 2026-03-21

- Moving on to `dotmem` for memory management
- Vendored `documentation-writer` skill
- `skills/grill-me/` - Broadened scope to cover writing (not just code/design). Added `references/techniques.md` with four questioning techniques: pre-mortem, five whys, second-order effects, steel-man. Skill draws from them naturally without announcing which one it's using.

## 2026-03-20

- `claude/settings.json` - Deny `gh issue comment`, `gh pr comment`, and `gh pr review` to prevent Claude from posting GitHub comments on the user's behalf
- `skills/grill-me/` - Vendor verbatim from mattpocock/skills: relentless design interview skill, stress-tests plans by walking each branch of the decision tree
- `skills/ubiquitous-language/` - Vendor verbatim from mattpocock/skills: DDD-style glossary extractor with canonical terms, aliase flagging, example dialogue, and incremental re-run support
- `skills/design-an-interface/` - Vendor verbatim from mattpocock/skills: parallel sub-agent interface design based on "Design It Twice" (A Philosophy of Software Design)
- `skills/red-green-refactor/SKILL.md` - Incorporate from mattpocock/skills tdd: tracer-bullet-first testing, behavior-vs-implementation test philosophy, per-cycle sanity check, anti-horizontal-slices guardrail
- `skills/technical-spec-writer/SKILL.md` - Incorporate from mattpocock/skills write-a-prd + prd-to-plan: relentless interview in step 1, deep module design lens in step 3, Durable Decisions spec section, vertical slice framing in implementation order
- `skills/skill-creator/SKILL.md` - Incorporate from mattpocock/skills write-a-skill: tighten SKILL.md line target to 100 lines, add review checklist

## 2026-03-17

- `skills/tracer-bullet/` - New skill: plan and execute risky technical changes by identifying the riskiest assumption, designing a minimal end-to-end tracer bullet test, then growing the implementation in phased red-green-refactor cycles. Combines RAT (what to validate), tracer bullet (thin vertical slice), and red-green-refactor (execution cadence). Includes research references backing the approach.

## 2026-03-15

- `skills/review-comments/SKILL.md` - Fix script path resolution: use `$SKILL_SCRIPT` discovery pattern that checks both `~/.claude/skills/` and `~/.pi/agent/skills/` so the bundled script is found regardless of which tool runs the skill (was using a bare relative path that resolved against the project CWD and always failed)

## 2026-03-14

- `skills/review-comments/` - New skill: fetch and act on PR review comments. Auto-detects repo/PR from git context, filters by reviewer (defaults to Copilot), fetches latest review only (or all with `--all` for final pass)
- `claude/settings.json` - Added permission for `review-comments/scripts/fetch-comments.sh`
- `install.sh` - Strip trailing slash from skill_dir in glob expansion before passing to `basename`/`link`

## 2026-03-13

- `claude/CLAUDE.md`, `CLAUDE.md` (project), `pi/AGENTS.md` - Added explicit GitHub interaction restriction: never comment on GitHub on user's behalf. Draft PRs are OK; all other interactions require explicit user request. No exceptions.

## 2026-03-10

- `skills/red-green-refactor/SKILL.md` - Added cross-reference to `/simplify` (built-in Claude Code slash command) as the lightweight alternative for small or post-hoc cleanups that don't warrant the full cycle. Noted it is Claude Code-only and not available in pi.
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
