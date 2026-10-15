#!/bin/bash
BAT_PATH="/sys/class/power_supply/BAT1"
INTERVAL=30
NOTIFY_50="/tmp/.bat50notified"
NOTIFY_20="/tmp/.bat20notified"

while true; do
    status=$(cat "$BAT_PATH/status")
    capacity=$(cat "$BAT_PATH/capacity")

    if [[ "$status" == "Charging" ]]; then
        rm -f "$NOTIFY_50" "$NOTIFY_20"
        # brightnessctl -q set 100%
        sleep "$INTERVAL"
        continue
    fi

    if ((capacity <= 20)); then
        if [[ ! -f "$NOTIFY_20" ]]; then
            notify-send -u critical -t 0 "Battery Critical" "Battery is at ${capacity}%. Plugging in recommended."
            brightnessctl -q set 20%
            touch "$NOTIFY_20"
        fi
    elif ((capacity <= 50)); then
        if [[ ! -f "$NOTIFY_50" ]]; then
            notify-send -u normal -t 5000 "Battery Warning" "Battery is at ${capacity}%."
            touch "$NOTIFY_50"
        fi
        # brightnessctl -q set 100%
    else
        # brightnessctl -q set 100%
    fi

    sleep "$INTERVAL"
done
