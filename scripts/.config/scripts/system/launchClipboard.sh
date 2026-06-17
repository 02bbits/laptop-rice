#!/usr/bin/env bash

tmp_dir="/tmp/cliphist"
rm -rf "$tmp_dir"

if [[ -n "$1" ]]; then
    cliphist decode <<<"$1" | wl-copy
    exit
fi

mkdir -p "$tmp_dir"

read -r -d '' prog <<EOF
/^[0-9]+\s<meta http-equiv=/ { next }
match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
    system("echo " grp[1] "\\\\\t | cliphist decode >$tmp_dir/"grp[1]"."grp[3])
    print \$0"\0icon\x1f$tmp_dir/"grp[1]"."grp[3]
    next
}
1
EOF
# | sed 's/\[\[ binary data[^]]*\]\]//g'
choice=$(cliphist list | gawk "$prog" | fuzzel -d --config $HOME/.config/fuzzel/clipboard.ini)
# cliphist list | strings | rg -F -- "$choice" | awk '{print $1}' | head -n 1 | tr -d '\n' | cliphist decode | wl-copy
cliphist list | rg -F -- "$choice" | cliphist decode | wl-copy
