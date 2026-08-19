#!/bin/bash
# Open set of apps

CONFIG="$HOME/.config/rofi/minimal_menu.rasi"
sets="󰇄  Productivity \n󰅱  Develop \n󰊗  Gaming \n  Security Lab"

option="$(echo -e "$sets" | rofi \
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
