#!/bin/sh

set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}

if ! command -v stow >/dev/null 2>&1; then
    echo "GNU Stow is required but was not found in PATH." >&2
    exit 1
fi

for package in nvim ghostty zellij fish; do
    target="$config_home/$package"

    # Remove links made by the old package/.config/package layout. Do not
    # disturb links that point anywhere else.
    if [ -L "$target" ]; then
        link=$(readlink "$target")
        case "$link" in
            *dotfiles/"$package"/.config/"$package")
                unlink "$target"
                ;;
        esac
    fi

    mkdir -p "$target"
    stow --restow --dir="$repo_root" --target="$target" "$package"
done
