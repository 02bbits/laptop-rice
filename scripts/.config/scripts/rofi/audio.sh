#!/bin/bash
# Switch the default audio output

sinks=$(pactl -f json list sinks)
default=$(pactl get-default-sink)

index=$(jq -r --arg d "$default" '.[] | (if .name == $d then "•  " else "    " end) + .description' <<<"$sinks" | rofi \
    -dmenu -i -no-custom \
    -format i \
    -config "$HOME/.config/rofi/minimal-menu.rasi")
[[ -z "$index" ]] && exit

pactl set-default-sink "$(jq -r ".[$index].name" <<<"$sinks")"
notify-send -u low "Audio" "Output: $(jq -r ".[$index].description" <<<"$sinks")"
