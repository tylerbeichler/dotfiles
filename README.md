# dotfiles

Personal configuration for an [Omarchy](https://omarchy.org) desktop on Arch Linux. Covers Hyprland overrides, a custom Waybar layout, the deep-space theme, and a few quality-of-life hooks.

## Prerequisites

- [Omarchy](https://omarchy.org) installed and working
- `jq` and `curl` (for the weather module)
- JetBrainsMono Nerd Font

## Installation

```bash
git clone https://github.com/novictus/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

`install.sh` creates symlinks from this repo into `~/.config`. Existing files are backed up with a `.bak` suffix before being replaced. Re-running the script is safe.

After installation, apply the theme:

```bash
omarchy-theme-set deep-space
```

## What's included

**Hyprland** — monitor layout, keybindings, idle/lock behavior, and look-and-feel tweaks (window rounding, etc.). These layer on top of Omarchy's defaults rather than replacing them.

**Waybar** — custom bar layout with date/time on the left, workspaces centered, and system indicators on the right. Includes a weather module powered by [Open-Meteo](https://open-meteo.com) (no API key required) using IP-based geolocation.

**deep-space theme** — dark midnight-blue base with a cyan accent. Covers terminal colors, Hyprland borders, btop, Waybar, and Neovim. Background images cycle on login and lock — drop additional images into `config/omarchy/themes/deep-space/backgrounds/` and re-run `omarchy-theme-set deep-space` to register them.

**Omarchy hooks** — background cycling on session start and screen lock. No wallpaper changes during an active session.

**Claude Code** — a `/theme` command for generating new Omarchy themes via parallel AI subagents. Requires [Claude Code](https://claude.ai/code).

## Keybindings added

| Binding | Action |
|---|---|
| `Super + Shift + R` | Reload UI (Hyprland, Waybar, Mako) |
| `Super + Ctrl + L` | Lock screen |

## Notes

The `config/omarchy/current/` directory is excluded from the repo — it's managed by Omarchy and changes with every theme switch.

Monitors are configured in `config/hypr/monitors.conf` for a specific 3-monitor setup. Adjust or clear that file for different hardware.

`settings.local.json` (Claude Code session permissions) is gitignored and intentionally not tracked.
