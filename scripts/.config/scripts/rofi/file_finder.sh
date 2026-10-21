#!/bin/bash
# Everything-style finder: fuzzy-search files and folders under ~, open with the default app.
# Excluded: the Windows mount (~1M files on NTFS) and app/build trees. fd also skips .gitignore'd paths.

list=$(mktemp)
trap 'rm -f "$list"' EXIT

# NUL-separated so names containing newlines stay one entry
fd . "$HOME" --type f --type d -0 \
    -E /Mounts -E /Applications -E /deps -E /go -E /R 2>/dev/null >"$list"

# show newlines as spaces and $HOME as ~; rofi returns the index, so the real path is used
index=$(
    sed -z "s/\n/ /g; s;^$HOME;~;" "$list" |
        tr '\0' '\n' |
        rofi -dmenu -i -format i \
            -sort -sorting-method fzf \
            -disable-history -no-custom \
            -p "Find: " \
            -config "$HOME/.config/rofi/minimal_menu.rasi"
)

[[ -z "$index" ]] && exit

sed -z -n "$((index + 1))p" "$list" | xargs -0 xdg-open
