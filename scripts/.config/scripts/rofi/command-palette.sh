#!/bin/bash
# Command palette. Type a name or its number; a unique match launches instantly.

SCRIPTS="$HOME/.config/scripts/rofi"
CONFIG="$HOME/.config/rofi/command-palette.rasi"

# icon|command|script — numbers come from the order, so add or move lines freely
commands="\
󰖩|wifi|wifi.sh
|bluetooth|bluetooth.sh
|app-sets|appgroups.sh
󰈞|files|filefinder.sh
|clipboard|clipboard.sh
|weather|weather.sh
󰋩|wallpaper|wallpaper.sh
󰈈|grab-text|ocr.sh
|scan-qr|qr.sh
|pick-color|colorpicker.sh
󰈮|snippets|snippets.sh
󰎆|player|media.sh
󱎫|timer|timer.sh
󰴜|open-link|link.sh
󰖟|web-search|websearch.sh
|dotfiles|config.sh
|audio-out|audio.sh
󰌌|keybinds|keys.sh
|screen-time|screentime.sh
󰈙|quick-note|note.sh"

# Unused:
# ⏻|power|power.sh
# 󰍹|display|display.sh

mapfile -t scripts < <(cut -d'|' -f3 <<<"$commands")

source "$SCRIPTS/glyph-icon.sh"

# Rows are "name<TAB>01" plus an icon image (see glyph-icon.sh for why it's an image).
# The number stays plain text so typing it matches.
rows() {
    local n=0 icon name script
    while IFS='|' read -r icon name script; do
        n=$((n + 1))
        printf '%s\t%02d\0icon\x1f%s\n' "$name" "$n" "$(glyph_icon "$icon")"
    done <<<"$commands"
}

chosen_index=$(rows | rofi \
    -dmenu -i \
    -matching prefix \
    -auto-select \
    -format i \
    -theme-str "textbox-k3 { content: \"01–${#scripts[@]}\"; }" \
    -config "$CONFIG")

[[ -z "$chosen_index" ]] && exit

bash "$SCRIPTS/${scripts[$chosen_index]}"
