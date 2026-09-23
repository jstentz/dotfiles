# Dotfiles

The repository keeps each application's configuration directly in a top-level
directory:

- `nvim/` installs into `~/.config/nvim`
- `ghostty/` installs into `~/.config/ghostty`
- `zellij/` installs into `~/.config/zellij`

## Installation

Install [GNU Stow](https://www.gnu.org/software/stow/), clone the repository,
and run:

```sh
./stow.sh
```

The script uses `$XDG_CONFIG_HOME` when it is set and otherwise installs into
`~/.config`. It also replaces symlinks created by the repository's previous
nested Stow layout.

Run the script again after adding a new file or changing the layout. Changes to
files that are already linked take effect immediately.
