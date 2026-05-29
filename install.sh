#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
    local src="$DOTFILES/$1"
    local dst="$HOME/$2"
    mkdir -p "$(dirname "$dst")"
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        echo "  backing up $dst"
        mv "$dst" "${dst}.bak"
    fi
    ln -sfn "$src" "$dst"
    echo "  linked $dst"
}

echo "Installing dotfiles..."

# Hyprland user overrides
link config/hypr .config/hypr

# Omarchy customizations
link config/omarchy/branding   .config/omarchy/branding
link config/omarchy/extensions .config/omarchy/extensions
link config/omarchy/hooks      .config/omarchy/hooks
link config/omarchy/themes     .config/omarchy/themes

# Claude Code config
link .claude/commands         .claude/commands
link .claude/settings.json    .claude/settings.json
link .claude/keybindings.json .claude/keybindings.json

# Session environment (also prepends ~/dotfiles/bin to PATH for user script overrides)
link config/uwsm/default .config/uwsm/default

# App configs — uncomment as you add them to the repo
link config/waybar     .config/waybar
# link config/foot      .config/foot
# link config/ghostty   .config/ghostty
# link config/mako      .config/mako
# link config/walker    .config/walker
# link config/nvim      .config/nvim
# link config/lazygit   .config/lazygit
# link config/btop      .config/btop
# link config/fastfetch .config/fastfetch
# link config/git       .config/git
# link config/starship.toml .config/starship.toml

echo "Done."
