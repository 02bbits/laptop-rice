#!/bin/bash
# Media controls for the active player

track=$(playerctl metadata --format '{{artist}} - {{title}}' 2>/dev/null)
[[ -z "$track" ]] && track="Nothing playing"

option=$(echo -e "󰐎  Play/Pause\n󰒭  Next\n󰒮  Previous" | rofi \
    -dmenu \
    -mesg "$track" \
    -config "$HOME/.config/rofi/minimal_menu.rasi")

case "$option" in
*Play*) playerctl play-pause ;;
*Next*) playerctl next ;;
*Previous*) playerctl previous ;;
esac
