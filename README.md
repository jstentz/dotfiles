# Dotfiles

The repository keeps each application's configuration directly in a top-level
directory:

- `nvim/` installs into `~/.config/nvim`
- `ghostty/` installs into `~/.config/ghostty`
- `zellij/` installs into `~/.config/zellij`
- `fish/` installs into `~/.config/fish`
- `hypr/` installs into `~/.config/hypr`
- `waybar/` installs into `~/.config/waybar`

## Installation

Install [GNU Stow](https://www.gnu.org/software/stow/), clone the repository,
and run:

```sh
./stow.sh
```

The script uses `$XDG_CONFIG_HOME` when it is set and otherwise installs into
`~/.config`. It also replaces symlinks created by the repository's previous
nested Stow layout.

If Hyprland has already generated `hypr/hyprland.lua` in your config directory,
move it to a backup location before running the script. Stow reports a conflict
when an existing regular file occupies the path it needs to link.

Changes to files that are already linked take effect immediately. To add a new
configuration file, create it under the matching directory in this repository
and rerun the script. Stow does not automatically copy new files created under
`~/.config` back into the repository.

## Hyprland

The Hyprland config uses these Arch packages.

| Packages | Used for |
| --- | --- |
| `hyprland`, `hyprpaper`, `waybar` | Desktop session, wallpaper, and top bar |
| `kitty`, `dolphin`, `hyprlauncher` | Terminal, file manager, and launcher shortcuts |
| `wireplumber`, `brightnessctl`, `playerctl` | Volume, brightness, and media keys |
| `hyprshutdown` | Optional graphical logout |

Hyprland starts Hyprpaper and Waybar when you log in. To start Waybar in an
existing Hyprland session, run `waybar` from a terminal. The wallpaper is
bundled at `hypr/wallpaper.jpeg`, and Stow links it alongside `hyprpaper.conf`.
