#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

DRY_RUN=false
for arg in "$@"; do
  case "$arg" in
    --dry-run|-n) DRY_RUN=true ;;
    *) echo "Unknown option: $arg"; exit 1 ;;
  esac
done

link() {
  local src="$1"
  local dest="$2"

  if $DRY_RUN; then
    echo "[dry-run] Would link $dest -> $src"
    return
  fi

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

# Deep-merge base settings into the live file.
# - Objects merge recursively (base wins for shared scalar keys)
# - Permission arrays (allow, deny, ask) are concatenated and deduplicated
# - Machine-only keys (hooks, plugins) are preserved
merge_settings() {
  local base="$1"
  local target="$2"

  if ! command -v jq >/dev/null 2>&1; then
    echo "ERROR: jq is required for settings merge (https://jqlang.github.io/jq/)"
    exit 1
  fi

  if [ ! -e "$target" ] && [ ! -L "$target" ]; then
    if $DRY_RUN; then
      echo "[dry-run] Would copy $base -> $target (new file)"
      return
    fi
    mkdir -p "$(dirname "$target")"
    cp "$base" "$target"
    echo "Copied $base -> $target (new file)"
    return
  fi

  # If target is still a symlink (old install), replace with a copy of the
  # base. There are no machine-local keys to preserve in a symlinked file.
  if [ -L "$target" ]; then
    if $DRY_RUN; then
      echo "[dry-run] Would replace symlink $target with merged file"
      return
    fi
    rm "$target"
    cp "$base" "$target"
    echo "Migrated $target from symlink to merged file"
    return
  fi

  local merged
  merged=$(jq -s '
    def merge_arrays: map(. // []) | add | unique;
    .[0] as $local | .[1] as $base |
    ($local * $base) |
    .permissions.allow = ([$local.permissions.allow, $base.permissions.allow] | merge_arrays) |
    .permissions.deny = ([$local.permissions.deny, $base.permissions.deny] | merge_arrays) |
    .permissions.ask = ([$local.permissions.ask, $base.permissions.ask] | merge_arrays)
  ' "$target" "$base")

  local current_sorted merged_sorted
  current_sorted=$(jq --sort-keys . "$target")
  merged_sorted=$(echo "$merged" | jq --sort-keys .)

  if [ "$current_sorted" = "$merged_sorted" ]; then
    echo "Settings $target already up to date"
    return
  fi

  echo "Settings diff for $target:"
  diff -u --label "current" --label "merged" \
    <(echo "$current_sorted") <(echo "$merged_sorted") || true

  if $DRY_RUN; then
    return
  fi

  echo "$merged" | jq . > "${target}.tmp" && mv "${target}.tmp" "$target"
  echo "Merged $base -> $target"
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
merge_settings "$SCRIPT_DIR/claude/settings.json" "$HOME/.claude/settings.json"
link "$SCRIPT_DIR/claude/output-styles" "$HOME/.claude/output-styles"
link_skills "$HOME/.claude/skills"

echo ""
echo "=== pi ==="
link "$SCRIPT_DIR/pi/AGENTS.md" "$HOME/.pi/agent/AGENTS.md"
link_skills "$HOME/.pi/agent/skills"
link "$SCRIPT_DIR/pi/extensions" "$HOME/.pi/agent/extensions"

echo ""
echo "Done. Run ./uninstall.sh to remove symlinks."
