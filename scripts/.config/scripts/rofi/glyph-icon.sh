# Sourced, not run. glyph_icon <glyph> prints the path of a cached PNG of that Nerd Font glyph.
# rofi can put a tile (background, radius, border) behind an image icon but not behind a text glyph,
# so menus that want icon tiles pass this as the row's icon: "text\0icon\x1f$(glyph_icon "")".
# Cached by the glyph's bytes, so changing a glyph redraws it. #a8a8a8 is @muted from theme.rasi.

glyph_icon() {
    local dir="$HOME/.cache/rofi-glyph-icons" png
    png="$dir/$(printf '%s' "$1" | od -An -tx1 | tr -d ' \n').png"
    if [[ ! -f "$png" ]]; then
        mkdir -p "$dir"
        magick -background none -fill '#a8a8a8' -font FiraCode-Nerd-Font-Mono-Reg -pointsize 64 \
            label:"$1" -trim -resize 56x56 -gravity center -extent 72x72 "$png"
    fi
    printf '%s' "$png"
}
