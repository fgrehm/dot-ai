---
name: end-of-session
description: >
  Flush working context to disk before ending a coding session. Use when the user
  says things like "let's wrap up", "end of session", "call it a session", "flush to
  disk", "save context", "anything to persist?", or signals they're done working. Also invoke proactively
  when context is getting long and the user hasn't explicitly saved progress.
---

# End of Session

Systematic checklist to persist everything from working memory to disk before a
session ends. Run through each section and report what was found/done.

## 1. Uncommitted changes

Check `git status` and `git diff --stat` in the working directory.

- If there are staged or unstaged changes, ask the user if they want to commit.
- If clean, confirm and move on.

## 2. Spec and doc status

Scan for specs, roadmaps, or task lists that were worked on during the session.

- Mark completed items as done (checkboxes, status fields).
- Update spec status headers (e.g., "ready for implementation" to "implemented").
- Update roadmap entries if milestones were hit.
- Update project-level docs (README, CHANGELOG, architecture docs) if new features landed.

Only update docs that are stale relative to what was actually built. Don't touch
docs that are already accurate.

## 3. Persistent memory

Review the session for learnings worth preserving across sessions. Prefer
lightweight memory files (auto-memory, notes) over project-level docs like
CLAUDE.md or AGENTS.md. Only update those heavyweight files for major learnings
or architectural decisions. When in doubt, ask the user before touching them.

Worth saving (to memory files):
- Stable patterns confirmed during the session
- Gotchas and debugging insights (e.g., stale binary issues, tool quirks)
- User preferences discovered (workflow, naming, communication style)
- Architecture decisions made

Not worth saving:
- Session-specific task details or temporary state
- Things already documented in project docs
- Speculative conclusions from a single observation

Check existing memory first to avoid duplicates. Update existing entries rather
than adding new ones when possible.

## 4. Dangling work

Scan for anything left in a half-done state:

- TODOs or FIXMEs added during the session without resolution
- Tests that were skipped or marked pending
- Files that were read but not updated when they should have been
- Specs written but not linked from roadmaps or backlogs

Flag anything found and ask the user how to handle it.

## 5. Report

Summarize what was persisted and what's still pending. Keep it short:

- Commits made (count + last hash)
- Docs updated (list)
- Memory entries added/updated (list)
- Dangling items (if any)
- Unpushed commits (remind user if ahead of remote)
