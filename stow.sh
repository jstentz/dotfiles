#!/bin/sh

set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}

if ! command -v stow >/dev/null 2>&1; then
    echo "GNU Stow is required but was not found in PATH." >&2
    exit 1
fi

for package in nvim ghostty zellij fish hypr noctalia; do
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

# Noctalia writes Settings overrides under XDG_STATE_HOME.
noctalia_state=${XDG_STATE_HOME:-"$HOME/.local/state"}/noctalia
settings_source="$repo_root/noctalia-state/settings.toml"
settings_target="$noctalia_state/settings.toml"

mkdir -p "$noctalia_state"
if [ -L "$settings_target" ] && [ "$settings_target" -ef "$settings_source" ]; then
    :
elif [ -e "$settings_target" ] || [ -L "$settings_target" ]; then
    echo "Keeping existing Noctalia settings at $settings_target. Move that file aside and rerun to use the repo settings." >&2
else
    ln -s "$settings_source" "$settings_target"
fi
