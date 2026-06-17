#! /bin/bash

CONFIG_FILE="$HOME/.config/rofi/command.rasi"
SCRIPT_DIR="$HOME/.config/scripts/hyprland/scripts/"

# kill rofi if another instance is alr running
if pgrep -x "rofi" >/dev/null; then
    pkill rofi
fi

option=$(ls $SCRIPT_DIR | rofi -i -dmenu -config $CONFIG_FILE)
bash $SCRIPT_DIR/$option
