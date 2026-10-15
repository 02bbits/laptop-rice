#!/bin/bash
# Countdown timer, notifies when done. Type any number for custom minutes.

mins=$(echo -e "5\n25\n50" | rofi \
    -dmenu \
    -p "Minutes: " \
    -config "$HOME/.config/rofi/minimal_menu.rasi")
[[ "$mins" =~ ^[0-9]+$ ]] || exit

notify-send -u low "Timer" "$mins min started."
sleep "${mins}m"
notify-send -u critical "Timer" "$mins min is up."
