# Scratchpad

Observations and rough notes. Review before each round of changes.
Promote to tasks or delete when stale.

---

- `skill-creator` vendor update deferred (2026-03-17): upstream has diverged significantly from pinned commit `1ed29a03` ([tree](https://github.com/anthropics/skills/tree/1ed29a03dc852d30fa6ef2ca53a67dc2c2c2c563/skills/skill-creator)). Latest is `b0cbd3df` ([tree](https://github.com/anthropics/skills/tree/b0cbd3df1533b396d281a6886d5132f623393a9c/skills/skill-creator)). The new SKILL.md is a complete rewrite focused on a test-eval loop (subagents, browser reviewer, description optimizer). Pulling just the SKILL.md would break it -- the new version references many new files not present locally (`agents/grader.md`, `eval-viewer/generate_review.py`, `scripts/run_loop.py`, etc.). A full vendor update also removes `scripts/init_skill.py`, `references/workflows.md`, `references/output-patterns.md`. Do a full update when there's a concrete need for the eval capabilities. Note: local changes to skill-creator now tracked in README.md.

- New skill idea: `readme-driven-development` or `docs-driven-development`
- `.ai/` convention: agents use `.ai/MEMORY.md` per project (gitignored scratchpad). Future idea: back it with a separate git repo so memory is versioned and portable without polluting the main project history. See Beads (https://github.com/steveyegge/beads) as a reference for git-backed agent memory.
