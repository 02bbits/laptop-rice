#!/bin/bash
# Copy a snippet, one per line in snippets.txt

SNIPPETS="$(dirname "$0")/snippets.txt"

chosen=$(rofi -dmenu -i -p "Snippet: " -config "$HOME/.config/rofi/minimal-menu.rasi" <"$SNIPPETS")
[[ -z "$chosen" ]] && exit

printf '%s' "$chosen" | wl-copy
