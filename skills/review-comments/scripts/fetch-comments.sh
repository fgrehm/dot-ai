#!/usr/bin/env bash
set -euo pipefail

# Fetch pull request review comments from GitHub
# Usage: fetch-comments.sh [--all] [--reviewer FILTER] [REPO] [PR_NUMBER]
#
# Options:
#   --all              Fetch comments from all reviews (default: latest only)
#   --reviewer FILTER  Filter reviews by author login (case-insensitive substring match)
#                      Special shorthand: "copilot" matches the Copilot bot
#
# Environment detection:
#   Repo and PR are auto-detected from git context via `gh`
#
# Examples:
#   fetch-comments.sh                          # Latest review (any reviewer)
#   fetch-comments.sh --reviewer copilot       # Latest Copilot review
#   fetch-comments.sh --all                    # All reviews
#   fetch-comments.sh --all --reviewer copilot # All Copilot reviews
#   fetch-comments.sh owner/repo 8            # Explicit repo and PR

FETCH_ALL=false
REVIEWER_FILTER=""
REPO=""
PR_NUM=""

while [[ $# -gt 0 ]]; do
  case $1 in
  --all)
    FETCH_ALL=true
    shift
    ;;
  --reviewer)
    REVIEWER_FILTER=$2
    shift 2
    ;;
  *)
    if [[ -z "$REPO" ]]; then
      REPO=$1
    elif [[ -z "$PR_NUM" ]]; then
      PR_NUM=$1
    fi
    shift
    ;;
  esac
done

# Auto-detect repo
if [[ -z "$REPO" ]]; then
  REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null || echo "")
  if [[ -z "$REPO" ]]; then
    echo "Error: Could not auto-detect repo. Specify as: $0 REPO PR_NUM" >&2
    exit 1
  fi
fi

# Auto-detect PR number
if [[ -z "$PR_NUM" ]]; then
  if gh pr view --json number >/dev/null 2>&1; then
    PR_NUM=$(gh pr view --json number --jq .number)
  else
    echo "Error: Could not auto-detect PR number. Specify as: $0 [REPO] PR_NUM" >&2
    echo "Or create a PR for your current branch first." >&2
    exit 1
  fi
fi

# Build jq filter for reviews. Always exclude the PR author's own "review"
# (the body-only COMMENTED review with no inline comments).
if [[ -n "$REVIEWER_FILTER" ]]; then
  # "copilot" shorthand matches the bot's full login
  lc_filter=$(echo "$REVIEWER_FILTER" | tr '[:upper:]' '[:lower:]')
  jq_select='[.[] | select((.user.login | ascii_downcase) | test($filter))]'
else
  jq_select='[.[] | select(.body != null and .body != "")]'
fi

REVIEWS_JSON=$(gh api "repos/$REPO/pulls/$PR_NUM/reviews" --paginate 2>/dev/null |
  jq --arg filter "${lc_filter:-}" "$jq_select | sort_by(.submitted_at)")

REVIEW_COUNT=$(echo "$REVIEWS_JSON" | jq 'length')

if [[ "$REVIEW_COUNT" -eq 0 ]]; then
  if [[ -n "$REVIEWER_FILTER" ]]; then
    echo "No reviews matching '$REVIEWER_FILTER' on $REPO PR #$PR_NUM"
  else
    echo "No reviews found on $REPO PR #$PR_NUM"
  fi
  exit 0
fi

if [[ "$FETCH_ALL" == true ]]; then
  SELECTED=$(echo "$REVIEWS_JSON" | jq -c '.[]')
  echo "=== Review Comments ($REPO PR #$PR_NUM, all $REVIEW_COUNT reviews) ==="
else
  SELECTED=$(echo "$REVIEWS_JSON" | jq -c '.[-1]')
  echo "=== Review Comments ($REPO PR #$PR_NUM, latest review) ==="
fi
echo

echo "$SELECTED" | while IFS= read -r review; do
  review_id=$(echo "$review" | jq -r '.id')
  reviewer=$(echo "$review" | jq -r '.user.login')
  submitted=$(echo "$review" | jq -r '.submitted_at')

  comments=$(gh api "repos/$REPO/pulls/$PR_NUM/reviews/$review_id/comments" --paginate 2>/dev/null)
  count=$(echo "$comments" | jq 'length')

  if [[ "$count" -eq 0 ]]; then
    continue
  fi

  if [[ "$FETCH_ALL" == true ]]; then
    echo "--- $reviewer ($submitted, $count comments) ---"
    echo
  fi

  echo "$comments" | jq -r '
    .[] |
    "\(.path):\(.line // "?") (\(.created_at))\n\(.body)\n---\n"
  '
done
