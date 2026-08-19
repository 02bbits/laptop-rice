#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
THEME="$HOME/.config/rofi/wallpaper.rasi"

# build list of wallpapers as icon paths
chosen=$(find "$WALLPAPER_DIR" \
    -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" -o -iname "*.gif" \) |
    sort |
    while read -r file; do
        name=$(basename "$file" | sed 's/\.[^.]*$//')
        # rofi icon format: "label\0icon\x1fpath"
        printf "%s\0icon\x1f%s\n" "$name" "$file"
    done |
    rofi \
        -dmenu \
        -p "" \
        -theme "$THEME" \
        -theme-str 'element-text { enabled: false; size: 0px; }')

[[ -z "$chosen" ]] && exit

# find full path from chosen name
wallpaper=$(find "$WALLPAPER_DIR" -type f -name "${chosen}.*" | head -1)
[[ -z "$wallpaper" ]] && exit

awww img "$wallpaper" --transition-type outer --transition-pos 1600,800 --transition-duration 1.75 --transition-fps 120
