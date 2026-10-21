#!/bin/bash
# Launch the saved waybar style. `bar.sh toggle` switches default <-> ink first.
state="$HOME/.cache/waybar-style"
dir="$HOME/.config/waybar"

style=$(cat "$state" 2>/dev/null || echo default)
if [[ $1 == toggle ]]; then
    [[ $style == ink ]] && style=default || style=ink
    echo "$style" >"$state"
fi

pkill -x waybar
while pgrep -x waybar >/dev/null; do sleep 0.1; done

if [[ $style == ink ]]; then
    exec waybar -c "$dir/ink/config.jsonc" -s "$dir/ink/style.css"
else
    exec waybar
fi
