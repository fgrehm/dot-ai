#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1"
  local dest="$2"

  if [ -L "$dest" ]; then
    rm "$dest"
  elif [ -e "$dest" ]; then
    echo "Backing up $dest -> ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "Linked $dest -> $src"
}

echo "=== Shared ==="
link "$SCRIPT_DIR/skills" "$HOME/.agents/skills"

echo ""
echo "=== Claude Code ==="
link "$SCRIPT_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
link "$SCRIPT_DIR/claude/settings.json" "$HOME/.claude/settings.json"
link "$SCRIPT_DIR/claude/output-styles" "$HOME/.claude/output-styles"
link "$SCRIPT_DIR/skills" "$HOME/.claude/skills"

echo ""
echo "=== pi ==="
link "$SCRIPT_DIR/pi/AGENTS.md" "$HOME/.pi/agent/AGENTS.md"
link "$SCRIPT_DIR/skills" "$HOME/.pi/agent/skills"

echo ""
echo "Done. Run ./uninstall.sh to remove symlinks."
