# Dotfiles — Claude Context

This is novictus's personal dotfiles repo for an Omarchy Linux desktop.

## Repo structure

```
dotfiles/
├── .claude/           # Claude Code config (commands, settings, keybindings)
├── config/
│   ├── hypr/          # Hyprland user overrides (merged on top of Omarchy defaults)
│   ├── omarchy/
│   │   ├── branding/  # Custom branding assets
│   │   ├── extensions/
│   │   ├── hooks/     # Lifecycle hooks (post-boot, theme-set, etc.)
│   │   └── themes/    # Custom themes — deep-space is the current theme
│   └── waybar/        # Waybar config, style, and custom module scripts
└── install.sh         # Bootstraps symlinks: dotfiles/X → ~/.X
```

`install.sh` creates symlinks so edits in `~/dotfiles/` take effect immediately at `~/.config/`.

## Omarchy

Omarchy is an opinionated Hyprland desktop framework. Key paths:
- `~/.local/share/omarchy/` — Omarchy's managed files (do not edit directly)
- `~/.config/omarchy/` — user overrides (this repo manages `branding`, `extensions`, `hooks`, `themes`)
- `~/.config/omarchy/current/` — active theme state, managed by `omarchy-theme-set`

When adding or modifying a theme, write to `~/dotfiles/config/omarchy/themes/<name>/` and run `omarchy-theme-set <name>` to deploy it. The deploy copies all theme files into `~/.config/omarchy/current/theme/`, including the `backgrounds/` folder.

## Arctic-ocean theme palette

| Role      | Hex       |
|-----------|-----------|
| Background | `#080f1a` |
| Foreground | `#b8d4e8` |
| Accent (cyan) | `#00dce8` |
| Status medium (magenta) | `#c050a0` |
| Status high (coral) | `#d05060` |
| Clock (gold) | `#e8c858` |

## Waybar

Layout: `[omarchy icon · date+time · weather]  [workspaces]  [indicators · tray · system]`

- `config.jsonc` — module layout and configuration
- `style.css` — imports `../omarchy/current/theme/waybar.css`, then adds overrides
- `weather-detail.sh` — Open-Meteo API (no key required), IP geolocation via ipinfo.io

Reload UI: `Super+Shift+R` (runs `hyprctl reload; makoctl reload; pkill -x waybar; sleep 0.2; waybar`)

## Background cycling

Backgrounds in a theme's `backgrounds/` folder cycle on session events only (no timer):
- Login: `post-boot` hook → `omarchy-theme-bg-next`
- Lock/sleep: hypridle `lock_cmd` runs `omarchy-theme-bg-next` before locking

Lock screen: `Super+Ctrl+L`

## Omarchy hook system

Hooks live in `~/.config/omarchy/hooks/`. Named hooks or `.d/` directories of scripts:
```
hooks/
├── post-boot.d/
│   └── background-cycle.sh   # cycles wallpaper on login
└── theme-set.d/              # runs after any theme change
```

Run a hook manually: `omarchy-hook <name>`
