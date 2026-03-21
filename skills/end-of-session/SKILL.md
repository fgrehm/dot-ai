---
name: end-of-session
description: "Flush working context to disk before ending a coding session. Use when the user says things like let's wrap up, end of session, call it a session, flush to disk, save context, anything to persist?, or signals they're done working. Also invoke proactively when context is getting long and the user hasn't explicitly saved progress."
---

# End of Session

Systematic checklist to persist everything from working memory to disk before a
session ends. Run through each section and report what was found/done.

## 1. Collect state

Run the `collect.sh` script available in the root of this skill's directory from the project root to gather all session state in one pass. It outputs git status, uncommitted changes, unpushed commits, new TODOs/FIXMEs, and status-bearing docs.

## 2. Analyze and act

Using the collector output:

- **Uncommitted changes**: If there are staged or unstaged changes, ask the user if they want to commit.
- **Specs and docs**: Update status headers, checkboxes, or roadmap entries that are stale relative to what was built. Only touch docs that are actually out of date.

## 3. Persistent memory

Review the session for learnings worth preserving across sessions. Write learnings to your memory files. Only update heavyweight files like `CLAUDE.md` or `AGENTS.md` for major learnings or architectural decisions. When in doubt, ask the user before touching them.

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

## Related skills

If there's completed work ready for review, consider the `pr-opener` skill before wrapping up.
