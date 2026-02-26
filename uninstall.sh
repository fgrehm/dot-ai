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
unlink_path "$HOME/.claude/CLAUDE.md"
unlink_path "$HOME/.claude/skills"

echo ""
echo "Done."
