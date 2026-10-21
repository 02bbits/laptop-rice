#!/bin/bash
# Screen time per app. `--log` runs the logger (niri startup), no argument shows today's report.

DIR="$HOME/.local/share/screentime"
mkdir -p "$DIR"

if [[ $1 == --log ]]; then
    exec 9>"$DIR/.lock"
    flock -n 9 || exit
    # ponytail: 60s polling, so time away before the 5-min lock still counts; switch to niri event-stream if precision matters
    while sleep 60; do
        pgrep -x swaylock >/dev/null && continue
        app=$(niri msg -j focused-window 2>/dev/null | jq -r '.app_id // empty' 2>/dev/null)
        [[ -n "$app" ]] && echo "$app" >>"$DIR/$(date +%F).tsv"
    done
fi

today="$DIR/$(date +%F).tsv"
total=$(cat "$today" 2>/dev/null | wc -l)

sort "$today" 2>/dev/null | uniq -c | sort -rn |
    awk '{printf "%d:%02d   %s\n", $1 / 60, $1 % 60, $2}' |
    rofi -dmenu -no-custom \
        -mesg "Today: $((total / 60))h $(printf '%02d' $((total % 60)))m" \
        -config "$HOME/.config/rofi/minimal-menu.rasi" >/dev/null
