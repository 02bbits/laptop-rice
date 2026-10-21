#!/bin/bash
# Countdown timer, notifies and plays a sound when done. Type any number for custom minutes.

# Any wav/ogg/oga/flac file works here
SOUND="/usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga"

mins=$(
    echo -e "5\n10\n25\n50" | rofi \
        -theme-str 'entry{placeholder: "duration (min)";} listview { lines: 4; }' \
        -dmenu \
        -config "$HOME/.config/rofi/minimal.rasi"
)
[[ "$mins" =~ ^[0-9]+$ ]] || exit

notify-send -u low "Timer" "$mins min started."
sleep "${mins}m"
notify-send -u critical "Timer" "$mins min is up."
pw-play "$SOUND"
