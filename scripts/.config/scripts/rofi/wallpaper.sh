#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
THEME="$HOME/.config/rofi/wallpaper.rasi"
THUMBS="$HOME/.cache/wallpaper-thumbs"
mkdir -p "$THUMBS"

# rofi draws icons in a square box, so 16:9 images leave bands above and below.
# Square center-cropped thumbnails fill the tile; rebuilt only when the wallpaper is newer.
chosen=$(find "$WALLPAPER_DIR" \
    -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" -o -iname "*.gif" \) |
    sort |
    while read -r file; do
        name=$(basename "$file" | sed 's/\.[^.]*$//')
        thumb="$THUMBS/$name.png"
        [[ "$thumb" -nt "$file" ]] ||
            magick "$file[0]" -thumbnail 400x400^ -gravity center -extent 400x400 "$thumb"
        # rofi icon format: "label\0icon\x1fpath"
        printf "%s\0icon\x1f%s\n" "$name" "$thumb"
    done |
    rofi \
        -dmenu \
        -p "" \
        -theme "$THEME" \
        -theme-str 'element-text { enabled: false; size: 0px; } element-icon { size: 300px; }')

[[ -z "$chosen" ]] && exit

# find full path from chosen name
wallpaper=$(find "$WALLPAPER_DIR" -type f -name "${chosen}.*" | head -1)
[[ -z "$wallpaper" ]] && exit

awww img "$wallpaper" --transition-type outer --transition-pos 1600,800 --transition-duration 1.75 --transition-fps 120
