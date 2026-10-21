#!/bin/bash
# Everything-style finder: fuzzy-search files and folders under ~, open with the default app.
# Excluded: the Windows mount (~1M files on NTFS) and app/build trees. fd also skips .gitignore'd paths.

selection=$(
    fd . "$HOME" --type f --type d \
        -E /Mounts -E /Applications -E /deps -E /go -E /R 2>/dev/null |
        sed "s;^$HOME;~;" |
        rofi -dmenu -i \
            -sort -sorting-method fzf \
            -disable-history -no-custom \
            -p "Find: " \
            -config "$HOME/.config/rofi/filefinder.rasi"
)

[[ -z "$selection" ]] && exit

xdg-open "${selection/#\~/$HOME}"
