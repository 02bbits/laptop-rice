#!/bin/bash
# Searchable cheatsheet of the niri keybinds

sed -n '/^binds {/,/^}/p' "$HOME/.config/niri/config.kdl" |
    grep -v -E '^\s*//' |
    sed -nE '
        s/^\s+([^ {]+)[^{]*hotkey-overlay-title="([^"]*)".*/\1\t\2/p; t
        s/^\s+([^ {]+)[^{]*\{\s*(.*[^; ]);?\s*\}\s*$/\1\t\2/p
    ' |
    rofi -dmenu -i -no-custom \
        -config "$HOME/.config/rofi/minimal.rasi" -theme-str 'window {width: 600px;} entry { placeholder: "keybind"; }' -theme-str 'element-text { tab-stops: [190px]; }' >/dev/null
