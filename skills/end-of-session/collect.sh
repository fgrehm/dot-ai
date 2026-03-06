#!/bin/sh
# Collect session state for end-of-session review.
# Run from the project root. Output is meant for the agent to analyze.

set -e

echo "=== GIT STATUS ==="
git status -sb

echo ""
echo "=== UNCOMMITTED CHANGES ==="
git diff --stat
git diff --cached --stat

echo ""
echo "=== UNPUSHED COMMITS ==="
if git rev-parse --verify '@{u}' >/dev/null 2>&1; then
  git log --oneline '@{u}..HEAD'
else
  echo "(no upstream set, showing last 10)"
  git log --oneline -10
fi

echo ""
echo "=== RECENT TODOS/FIXMES ==="
# Check uncommitted changes for new TODO/FIXME/HACK annotations
git diff --unified=0 HEAD 2>/dev/null \
  | grep '^+' \
  | grep -v '^+++' \
  | grep -iE 'TODO|FIXME|HACK' \
  || echo "none in uncommitted changes"

echo ""
echo "=== SPECS AND DOCS ==="
# Find markdown files with Status: headers that might need updating
git ls-files '*.md' | xargs grep -li '^\*\*Status:\*\*\|^Status:' 2>/dev/null \
  || echo "no status-bearing docs found"
