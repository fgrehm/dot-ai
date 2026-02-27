#!/usr/bin/env bash
# Symlink an AI tool's auto-memory into the project root.
# Currently supports: Claude Code
#
# Usage: link-memory.sh [project-dir]
#   project-dir: defaults to git repo root, falls back to $PWD

set -euo pipefail

# Resolve project root (physical path, no symlinks)
if [ -n "${1:-}" ]; then
  project_dir="$(cd "$1" && pwd -P)"
elif git rev-parse --show-toplevel &>/dev/null; then
  project_dir="$(cd "$(git rev-parse --show-toplevel)" && pwd -P)"
else
  project_dir="$(pwd -P)"
fi

symlink_path="$project_dir/.ai/memory.md"

# --- Claude Code ---
claude_mangled="$(echo "$project_dir" | tr '/.' '-')"
claude_memory="$HOME/.claude/projects/${claude_mangled}/memory/MEMORY.md"

if [ -f "$claude_memory" ]; then
  memory_source="$claude_memory"
  memory_tool="Claude Code"
else
  echo "No memory file found." >&2
  echo "  Claude Code: $claude_memory (not found)" >&2
  echo "" >&2
  echo "Has the tool created a memory file for this project yet?" >&2
  exit 1
fi

# Create symlink
mkdir -p "$(dirname "$symlink_path")"
ln -sf "$memory_source" "$symlink_path"
echo "Linked $symlink_path -> $memory_source ($memory_tool)"

# Add to git local exclude if inside a git repo
git_dir="$(git -C "$project_dir" rev-parse --git-dir 2>/dev/null)" || true
if [ -n "$git_dir" ]; then
  # Make git-dir absolute
  case "$git_dir" in
    /*) ;;
    *)  git_dir="$project_dir/$git_dir" ;;
  esac

  exclude_file="$git_dir/info/exclude"
  mkdir -p "$(dirname "$exclude_file")"
  pattern=".ai/memory.md"
  if ! grep -qxF "$pattern" "$exclude_file" 2>/dev/null; then
    echo "$pattern" >> "$exclude_file"
    echo "Added '$pattern' to $exclude_file"
  fi
fi
