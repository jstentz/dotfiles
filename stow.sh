#!/bin/sh

set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}

if ! command -v stow >/dev/null 2>&1; then
    echo "GNU Stow is required but was not found in PATH." >&2
    exit 1
fi

packages='nvim ghostty zellij fish hypr noctalia umbriel'
if [ "$#" -gt 2 ]; then
    echo "Usage: $0 [package] or $0 <first-argument> <package>" >&2
    exit 1
fi
if [ "$#" -gt 0 ]; then
    selected=${2-$1}
    found=false
    for package in $packages; do
        if [ "$selected" = "$package" ]; then
            found=true
            break
        fi
    done
    if [ "$found" = false ]; then
        echo "Unknown package '$selected'. Available packages: $packages" >&2
        exit 1
    fi
    packages=$selected
fi

for package in $packages; do
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

    set --
    if [ "$package" = noctalia ]; then
        # Settings are linked into XDG_STATE_HOME below.
        set -- '--ignore=^settings\.toml$'
        gtk_sync="$target/sync-gtk-theme.sh"
        if [ -L "$gtk_sync" ] && [ "$(realpath -m -- "$gtk_sync")" = "$repo_root/noctalia/sync-gtk-theme.sh" ]; then
            unlink "$gtk_sync"
        fi
    fi

    mkdir -p "$target"
    stow --restow --dir="$repo_root" --target="$target" "$@" "$package"
done

if [ "${selected-noctalia}" != noctalia ]; then
    exit 0
fi

# Noctalia writes Settings overrides under XDG_STATE_HOME.
noctalia_state=${XDG_STATE_HOME:-"$HOME/.local/state"}/noctalia
settings_source="$repo_root/noctalia/settings.toml"
legacy_settings="$repo_root/noctalia-state/settings.toml"
settings_target="$noctalia_state/settings.toml"

mkdir -p "$noctalia_state"
if [ -L "$settings_target" ] && [ "$settings_target" -ef "$settings_source" ]; then
    :
elif [ -L "$settings_target" ] && [ "$(realpath -m -- "$settings_target")" = "$legacy_settings" ]; then
    ln -sfn "$settings_source" "$settings_target"
elif [ -e "$settings_target" ] || [ -L "$settings_target" ]; then
    echo "Keeping existing Noctalia settings at $settings_target. Move that file aside and rerun to use the repo settings." >&2
else
    ln -s "$settings_source" "$settings_target"
fi
