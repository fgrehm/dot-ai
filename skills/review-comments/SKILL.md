---
name: review-comments
description: Fetch and act on PR review comments. Auto-detects current PR from git context. Defaults to Copilot reviews (asks before fetching if no --reviewer specified). Fetches latest review by default (use --all for final pass). Use when returning to a PR after a review, or before merging for a final check of all accumulated feedback.
---

# Review Comments

## Quick Start

After pushing changes and triggering a review, return and run the script. The script is bundled with this skill - find it by checking candidate install locations:

```bash
SKILL_SCRIPT=$(ls \
  ~/.claude/skills/review-comments/scripts/fetch-comments.sh \
  ~/.pi/agent/skills/review-comments/scripts/fetch-comments.sh \
  2>/dev/null | head -1)
```

Then run it:

```bash
bash "$SKILL_SCRIPT"
```

The script will:
1. Auto-detect your repo and PR from git context via `gh`
2. Fetch comments from the **latest review only** (avoids outdated feedback)
3. Output formatted comments ready for action

If no `--reviewer` flag is given, default to Copilot reviews. Ask the user to confirm before fetching if you're unsure whether they want Copilot or a different reviewer.

## Usage Patterns

Set `SKILL_SCRIPT` as above, then:

### Latest review (recommended)

Fetch only the most recent review on your current PR:

```bash
# Copilot (default when invoked without --reviewer)
bash "$SKILL_SCRIPT" --reviewer copilot

# Specific reviewer
bash "$SKILL_SCRIPT" --reviewer octocat
```

### All reviews (final pass)

Before merging, check all accumulated feedback across all reviews to ensure nothing was missed:

```bash
bash "$SKILL_SCRIPT" --all --reviewer copilot
```

### No filter

Fetch reviews from all reviewers:

```bash
bash "$SKILL_SCRIPT" --all
```

### Manual repo/PR specification

If auto-detection doesn't work (different repo, no active branch):

```bash
bash "$SKILL_SCRIPT" owner/repo 8
```

## How I'll Use This

When you ask me to address review feedback:

1. **I run the script** - resolve `$SKILL_SCRIPT` as shown in Quick Start, then run it with `--reviewer copilot` (unless told otherwise) to fetch the latest comments
2. **I analyze and summarize** the feedback, categorizing by type
3. **I create an action plan** showing what's already fixed, what needs fixing, and severity
4. **We implement fixes** together, addressing real issues efficiently

## Technical Details

The script uses `gh` CLI to:
- Fetch reviews from `/repos/:owner/:repo/pulls/:pr/reviews` (paginated)
- Fetch comments per review from `/reviews/:id/comments` (paginated)
- Optionally filter reviews by author login (`--reviewer`, case-insensitive substring match)
- Format output with file:line + created_at + full comment body
