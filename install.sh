#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d%H%M%S)"

link_path() {
  local source=$1
  local target=$2

  if [ -e "$target" ] || [ -L "$target" ]; then
    if [ "$(readlink "$target" 2>/dev/null || true)" = "$source" ]; then
      return
    fi

    mkdir -p "$backup_dir$(dirname "$target")"
    mv "$target" "$backup_dir$target"
  fi

  mkdir -p "$(dirname "$target")"
  ln -s "$source" "$target"
}

link_path "$repo_dir/zshrc" "$HOME/.zshrc"
link_path "$repo_dir/zshenv" "$HOME/.zshenv"
link_path "$repo_dir/hypr" "$HOME/.config/hypr"
link_path "$repo_dir/waybar" "$HOME/.config/waybar"
link_path "$repo_dir/kitty" "$HOME/.config/kitty"
link_path "$repo_dir/opencode" "$HOME/.config/opencode"
link_path "$repo_dir/opendeck" "$HOME/.config/opendeck"

mkdir -p "$HOME/.local/bin"
for executable in "$repo_dir"/bin/*; do
  [ -e "$executable" ] || continue
  link_path "$executable" "$HOME/.local/bin/$(basename "$executable")"
done

if [ -d "$backup_dir" ]; then
  printf 'Existing files were backed up to %s\n' "$backup_dir"
fi
