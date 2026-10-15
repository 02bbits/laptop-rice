#!/bin/bash
# Drag-select a QR code / barcode on screen, copy its contents

region=$(slurp) || exit
text=$(grim -g "$region" - | zbarimg -q --raw - 2>/dev/null)

if [[ -z "$text" ]]; then
    notify-send -u low "QR scan" "No code found in selection."
    exit 1
fi

printf '%s' "$text" | wl-copy
notify-send -u low "QR scan" "$text"
