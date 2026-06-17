#!/bin/bash

WALL_DIR="$HOME/Pictures/wallpapers"
DATA_FILE="$HOME/.config/scripts/hyprland/data/currentWallpaper"

mapfile -t WALLS < <(find "$WALL_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.gif' \) -printf "%f\n")

# Let user pick one
CHOICE=$(printf "%s\n" "${WALLS[@]}" | fuzzel -d)
[ -z "$CHOICE" ] && exit 1

# Full path to chosen file
WALL="$WALL_DIR/$CHOICE"

swww img "$WALL" --transition-type outer --transition-pos 1600,800 --transition-duration 1.75 --transition-fps 120

# Save current wallpaper path
mkdir -p "$(dirname "$DATA_FILE")"
echo "$WALL" >"$DATA_FILE"
