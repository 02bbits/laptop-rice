#!/bin/bash
# Pick a search engine, type a query, open the results in the browser.
# Add engines as "icon|Name|URL prefix" lines; the icon is any Nerd Font glyph.

engines="\
|Google|https://www.google.com/search?q=
|GitHub|https://github.com/search?q=
󰑴|Google Scholar|https://scholar.google.com/scholar?q=
|YouTube|https://www.youtube.com/results?search_query=
|Arch Wiki|https://wiki.archlinux.org/index.php?search=
|Fedora Packages|https://packages.fedoraproject.org/search?query=
|Wikipedia|https://en.wikipedia.org/w/index.php?search="

MENU="$HOME/.config/rofi/minimal-menu-icons.rasi"
INPUT="$HOME/.config/rofi/minimal.rasi"

source "$(dirname "$0")/glyph-icon.sh"
mapfile -t names < <(cut -d'|' -f2 <<<"$engines")
mapfile -t prefixes < <(cut -d'|' -f3- <<<"$engines")

index=$(while IFS='|' read -r icon name _; do
    printf '%s\0icon\x1f%s\n' "$name" "$(glyph_icon "$icon")"
done <<<"$engines" | rofi -dmenu -i -no-custom -format i -config "$MENU")
[[ -z "$index" ]] && exit
engine=${names[$index]}

query=$(rofi -dmenu -config "$INPUT" \
    -theme-str "window { width: 600px; } mainbox { children: [inputbar]; } inputbar { border: 0px; } entry { placeholder: \"search $engine\"; }" </dev/null)
[[ -z "$query" ]] && exit

xdg-open "${prefixes[$index]}$(jq -rn --arg q "$query" '$q|@uri')"
