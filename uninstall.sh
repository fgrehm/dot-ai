#!/usr/bin/env bash
set -euo pipefail

unlink_path() {
  local path="$1"

  if [ -L "$path" ]; then
    rm "$path"
    echo "Removed symlink $path"

    if [ -e "${path}.bak" ]; then
      mv "${path}.bak" "$path"
      echo "Restored ${path}.bak -> $path"
    fi
  else
    echo "Skipping $path (not a symlink)"
  fi
}

echo "=== Claude Code ==="
unlink_path "$HOME/.claude/skills"
unlink_path "$HOME/.claude/output-styles"
unlink_path "$HOME/.claude/settings.json"
unlink_path "$HOME/.claude/CLAUDE.md"

echo ""
echo "=== pi ==="
unlink_path "$HOME/.pi/agent/skills"
unlink_path "$HOME/.pi/agent/AGENTS.md"

echo ""
echo "=== Shared ==="
unlink_path "$HOME/.agents/skills"

echo ""
echo "Done."
