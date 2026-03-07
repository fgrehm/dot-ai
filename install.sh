#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

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

# Clean up legacy chezmoi-managed symlinks (pointed to dotfiles repo config/claude/)
cleanup_legacy() {
  local target="$1"
  if [ -L "$target" ]; then
    local dest
    dest="$(readlink "$target")"
    if [[ "$dest" == */config/claude/* ]]; then
      echo "Removing legacy symlink $target -> $dest"
      rm "$target"
    fi
  fi
}

link_skills() {
  local target_dir="$1"

  # If the target is a symlink (e.g. old whole-dir install), remove it so we
  # can replace it with a real directory containing per-skill symlinks.
  if [ -L "$target_dir" ]; then
    echo "Removing symlink at $target_dir (replacing with per-skill symlinks)"
    rm "$target_dir"
  fi

  mkdir -p "$target_dir"

  # Safety: abort if target_dir still resolves to the source skills dir.
  # Writing through such a path would corrupt the repo.
  local target_real source_real
  target_real="$(cd "$target_dir" && pwd -P)"
  source_real="$(cd "$SCRIPT_DIR/skills" && pwd -P)"
  if [ "$target_real" = "$source_real" ]; then
    echo "ERROR: $target_dir resolves to source dir $source_real, skipping"
    return 1
  fi

  for skill_dir in "$SCRIPT_DIR/skills"/*/; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"
    link "$skill_dir" "$target_dir/$skill_name"
  done
}

cleanup_legacy "$HOME/.claude/CLAUDE.md"
cleanup_legacy "$HOME/.claude/settings.json"
cleanup_legacy "$HOME/.claude/output-styles"
cleanup_legacy "$HOME/.claude/skills"

echo "=== Claude Code ==="
link "$SCRIPT_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
link "$SCRIPT_DIR/claude/settings.json" "$HOME/.claude/settings.json"
link "$SCRIPT_DIR/claude/output-styles" "$HOME/.claude/output-styles"
link_skills "$HOME/.claude/skills"

echo ""
echo "=== pi ==="
link "$SCRIPT_DIR/pi/AGENTS.md" "$HOME/.pi/agent/AGENTS.md"
link_skills "$HOME/.pi/agent/skills"
link "$SCRIPT_DIR/pi/extensions" "$HOME/.pi/agent/extensions"

echo ""
echo "Done. Run ./uninstall.sh to remove symlinks."
