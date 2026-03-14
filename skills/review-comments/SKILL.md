---
name: review-comments
description: Fetch and act on PR review comments. Auto-detects current PR from git context. Defaults to Copilot reviews (asks before fetching if no --reviewer specified). Fetches latest review by default (use --all for final pass). Use when returning to a PR after a review, or before merging for a final check of all accumulated feedback.
---

# Review Comments

## Quick Start

After pushing changes and triggering a review, return and run the script:

```bash
scripts/fetch-comments.sh
```

The script will:
1. Auto-detect your repo and PR from git context via `gh`
2. Fetch comments from the **latest review only** (avoids outdated feedback)
3. Output formatted comments ready for action

If no `--reviewer` flag is given, default to Copilot reviews. Ask the user to confirm before fetching if you're unsure whether they want Copilot or a different reviewer.

## Usage Patterns

### Latest review (recommended)

Fetch only the most recent review on your current PR:

```bash
# Copilot (default when invoked without --reviewer)
scripts/fetch-comments.sh --reviewer copilot

# Specific reviewer
scripts/fetch-comments.sh --reviewer octocat
```

### All reviews (final pass)

Before merging, check all accumulated feedback across all reviews to ensure nothing was missed:

```bash
scripts/fetch-comments.sh --all --reviewer copilot
```

### No filter

Fetch reviews from all reviewers:

```bash
scripts/fetch-comments.sh --all
```

### Manual repo/PR specification

If auto-detection doesn't work (different repo, no active branch):

```bash
scripts/fetch-comments.sh owner/repo 8
```

## How I'll Use This

When you ask me to address review feedback:

1. **I run the script** (with `--reviewer copilot` unless told otherwise) to fetch the latest comments
2. **I analyze and summarize** the feedback, categorizing by type
3. **I create an action plan** showing what's already fixed, what needs fixing, and severity
4. **We implement fixes** together, addressing real issues efficiently

## Technical Details

The script uses `gh` CLI to:
- Fetch reviews from `/repos/:owner/:repo/pulls/:pr/reviews` (paginated)
- Fetch comments per review from `/reviews/:id/comments` (paginated)
- Optionally filter reviews by author login (`--reviewer`, case-insensitive substring match)
- Format output with file:line + created_at + full comment body
