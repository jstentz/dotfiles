#!/bin/sh

mode=$(noctalia msg theme-mode-get) || exit 1
case "$mode" in
    light) theme=Adwaita ;;
    dark) theme=Adwaita-dark ;;
    *) exit 1 ;;
esac

gsettings set org.gnome.desktop.interface gtk-theme "$theme"
