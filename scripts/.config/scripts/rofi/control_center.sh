#!/bin/bash

SCRIPTS="$HOME/.config/scripts/rofi"
CONFIG="$HOME/.config/rofi/center.rasi"

# \0icon\x1f<icon>
menu="\
/network    \t\t   󰖩
/bluetooth  \t\t   
/quickopen  \t\t   
/clipboard  \t\t   
/weather    \t\t   
/display    \t\t   󰍹
/wallpaper  \t\t   
/ocr        \t\t   
/qr         \t\t   
/color      \t\t   
/snippets   \t\t   
/media      \t\t   󰎆
/timer      \t\t   󰔛
/power      \t\t   ⏻
"

# Order must match the lines in $menu above.
# Comments here are just bash comments, safe to edit freely.
actions=(
    "$SCRIPTS/wifi.sh"        # wifi
    "$SCRIPTS/bluetooth.sh"   # bluetooth
    "$SCRIPTS/appgroups.sh"   # quickopen
    "$SCRIPTS/clipboard.sh"   # clipboard
    "$SCRIPTS/weather.sh"     # weather
    "$SCRIPTS/display.sh"     # display
    "$SCRIPTS/wallpaper.sh"   # wallpaper
    "$SCRIPTS/ocr.sh"         # ocr
    "$SCRIPTS/qr.sh"          # qr
    "$SCRIPTS/colorpicker.sh" # color
    "$SCRIPTS/snippets.sh"    # snippets
    "$SCRIPTS/media.sh"       # media
    "$SCRIPTS/timer.sh"       # timer
    "$SCRIPTS/power.sh"       # power
)

chosen_index=$(echo -en "$menu" | rofi \
    -dmenu \
    -i \
    -format i \
    -config "$CONFIG")

[[ -z "$chosen_index" ]] && exit

bash "${actions[$chosen_index]}"
