# Dotfiles

The repository keeps each application's configuration directly in a top-level
directory:

- `nvim/` installs into `~/.config/nvim`
- `ghostty/` installs into `~/.config/ghostty`
- `zellij/` installs into `~/.config/zellij`
- `fish/` installs into `~/.config/fish`
- `hypr/` installs into `~/.config/hypr`
- `noctalia/` installs into `~/.config/noctalia`

## Fresh install with Archinstall

1. Select the **Hyprland** desktop profile, **PipeWire** for audio, and
   **NetworkManager** for networking. Under **Applications → Power Management**,
   select **power-profiles-daemon**. Enable Bluetooth there if you want pairing
   in Noctalia.
2. Add the packages from the groups below that you want to use under
   **Additional packages**. Include the **Dotfiles setup** and **Hyprland and
   Noctalia** groups for this desktop. You can also install the packages after
   the first boot.
3. Clone or restore this repository and run `./stow.sh` as your normal user,
   preferably from a TTY before the first Hyprland login. Then select
   **Hyprland** at the login screen.

## Required packages on Arch Linux

Install the groups for the configurations you use. Package names below are
for `pacman`.

### Dotfiles setup

```sh
sudo pacman -S --needed git stow
```

### Neovim

```sh
sudo pacman -S --needed neovim curl tar gzip unzip gcc tree-sitter-cli nodejs npm ripgrep
```

The config requires Neovim 0.12 or newer and `tree-sitter-cli` 0.26.1 or newer.
Neovim builds Tree-sitter parsers on first launch, so install the CLI before
opening it. Node.js and npm let Mason install the configured TypeScript and
Python language servers. See the [Neovim README](nvim/README.md) for optional
tools, clipboard providers, and language toolchains.

### Terminal and shell

```sh
sudo pacman -S --needed ghostty zellij fish ttf-hack-nerd
```

Ghostty is configured to use Hack Nerd Font Mono.

### Hyprland and Noctalia

```sh
sudo pacman -S --needed hyprland noctalia upower kitty thunar \
  wireplumber brightnessctl playerctl adw-gtk-theme
```

Kitty and Dolphin power the terminal and file manager shortcuts. WirePlumber,
Brightnessctl, and Playerctl handle volume, brightness, and media keys.
Noctalia's GTK 3 and GTK 4 templates use `adw-gtk-theme` for app theming.
UPower provides battery status. If you skipped power management in Archinstall,
install `power-profiles-daemon` and enable it with
`sudo systemctl enable --now power-profiles-daemon.service`. Install
`hyprshutdown` if you want the graphical logout dialog.

## Installation

After installing the packages you need, clone the repository and run:

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

Hyprland starts Noctalia when you log in. Press **Super+R** for the app
launcher. Noctalia uses the bundled `hypr/wallpaper.jpeg` under the default
`~/.config` layout. If you use a custom `XDG_CONFIG_HOME`, update the wallpaper
path in `noctalia/config.toml`.

Noctalia Settings saves overrides to
`${XDG_STATE_HOME:-$HOME/.local/state}/noctalia/settings.toml`.
`./stow.sh` links that path to `noctalia/settings.toml` in this repo so
changes made in the app show up in Git. The script updates symlinks created by
the previous layout and leaves other existing settings files in place.
These overrides take precedence over `noctalia/config.toml`.

The Waybar config is available for manual use. Its **Keys** button uses
`python` and `hyprlauncher` to show active bindings that have a `description`
in `hyprland.lua`. Add a description to a binding and reload Hyprland to
include it in the next lookup.
