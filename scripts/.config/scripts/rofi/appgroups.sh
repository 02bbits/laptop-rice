#!/bin/bash
# Open set of apps

CONFIG="$HOME/.config/rofi/minimal-menu-icons.rasi"
# icon|name — the icon is any Nerd Font glyph, shown on a tile (glyph-icon.sh)
sets="󰇄|Productivity
󰅱|Develop
󰊗|Gaming
|Security Lab"

source "$(dirname "$0")/glyph-icon.sh"

option="$(while IFS='|' read -r icon name; do
    printf '%s\0icon\x1f%s\n' "$name" "$(glyph_icon "$icon")"
done <<<"$sets" | rofi \
    -dmenu \
    -config $CONFIG)"

case "$option" in
*Productivity*)
    flatpak run md.obsidian.Obsidian &
    ghostty &
    flatpak run app.zen_browser.zen &
    ;;
*Develop*)
    Discord &
    ~/.local/bin/zed &
    ghostty &
    flatpak run app.zen_browser.zen &
    ;;
*Gaming*)
    steam &
    Discord &
    flatpak run com.github.wwmm.easyeffects &
    ;;
*Security*)
    virt-manager -c qemu:///system --show-domain-console "Kali Main" &
    # flatpak run org.ghidra_sre.Ghidra &
    flatpak run md.obsidian.Obsidian &
    flatpak run app.zen_browser.zen &
    ;;
*)
    exit 0
    ;;
esac
