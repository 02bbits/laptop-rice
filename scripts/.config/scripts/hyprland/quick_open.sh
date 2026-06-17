#!/bin/bash
# Open set of apps

sets="󰇄 \tProductivity \n󰅱 \tDevelop \n󰊗 \tGaming \n \tSecurity Lab"

option="$(echo -e "$sets" | fuzzel -d -w 20 --minimal-lines --tabs 4)"

case "$option" in
*Productivity*)
    hyprctl dispatch workspace 4 && flatpak run md.obsidian.Obsidian &
    hyprctl dispatch workspace 10 && Discord &
    flatpak run app.zen_browser.zen &
    ;;
*Develop*)
    hyprctl dispatch workspace 10 && Discord &
    hyprctl dispatch workspace 3 && ~/.local/bin/zed &
    hyprctl dispatch workspace 1 && ghostty &
    flatpak run app.zen_browser.zen &
    ;;
*Gaming*)
    steam &
    Discord &
    flatpak run com.github.wwmm.easyeffects &
    ;;
*Security*)
    virt-manager -c qemu:///system --show-domain-console "Kali Lab" &
    hyprctl dispatch workspace 3 && flatpak run org.ghidra_sre.Ghidra &
    hyprctl dispatch workspace 4 && flatpak run md.obsidian.Obsidian &
    flatpak run app.zen_browser.zen &
    ;;
*)
    exit 0
    ;;
esac
