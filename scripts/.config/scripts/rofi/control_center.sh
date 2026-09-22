#!/bin/bash

SCRIPTS="$HOME/.config/scripts/rofi"
CONFIG="$HOME/.config/rofi/center.rasi"

# define entries: "icon  label" → script
declare -A actions=(
    ["󰖩  wifi"]="$SCRIPTS/wifi.sh"
    ["  bluetooth"]="$SCRIPTS/bluetooth.sh"
    ["  quickopen"]="$SCRIPTS/appgroups.sh"
    ["  clipboard"]="$SCRIPTS/clipboard.sh"
    ["󰖐  weather"]="$SCRIPTS/weather.sh"
    ["󰍹  display"]="$SCRIPTS/display.sh"
    ["󰸉  wallpaper"]="$SCRIPTS/wallpaper.sh"
    ["󱄺  ocr"]="$SCRIPTS/ocr.sh"
    # ["  snippets"]="$SCRIPTS/snippets.sh"
    # ["  color picker"]="$SCRIPTS/colorpicker.sh"
    # ["  power"]="$SCRIPTS/power.sh"
)

# build the menu list in a fixed order
menu="\
󰖩  wifi
  bluetooth
  quickopen
  clipboard
󰖐  weather
󰍹  display
󰸉  wallpaper
󱄺  ocr"

BAT=$(cat /sys/class/power_supply/BAT1/capacity)
TIME=$(date "+%H:%M")

chosen=$(echo "$menu" | rofi \
    -dmenu \
    -p "" \
    -config $CONFIG)

[[ -z "$chosen" ]] && exit

bash "${actions[$chosen]}"
