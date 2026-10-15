#!/bin/bash
# Pick a pixel on screen, copy its hex

hex=$(niri msg pick-color | grep -oE '#[0-9a-fA-F]{6}')
[[ -z "$hex" ]] && exit

printf '%s' "$hex" | wl-copy
notify-send -u low "Color picker" "$hex copied to clipboard."
