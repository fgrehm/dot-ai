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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

unlink_skills() {
  local target_dir="$1"
  if [ ! -d "$target_dir" ]; then
    echo "Skipping $target_dir (not a directory)"
    return
  fi
  for skill_dir in "$SCRIPT_DIR/skills"/*/; do
    skill_name="$(basename "$skill_dir")"
    unlink_path "$target_dir/$skill_name"
  done
}

echo "=== Claude Code ==="
unlink_skills "$HOME/.claude/skills"
unlink_path "$HOME/.claude/output-styles"
echo "Skipping $HOME/.claude/settings.json (merged file, not a symlink; edit manually)"
unlink_path "$HOME/.claude/CLAUDE.md"

echo ""
echo "=== pi ==="
unlink_path "$HOME/.pi/agent/extensions"
unlink_skills "$HOME/.pi/agent/skills"
unlink_path "$HOME/.pi/agent/AGENTS.md"

echo ""
echo "Done."
