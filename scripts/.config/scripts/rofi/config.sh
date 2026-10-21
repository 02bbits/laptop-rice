#!/bin/bash
# Pick any file in the dotfiles repo and edit it in nvim

DOTFILES="$HOME/dotfiles"

file=$(fd . --base-directory "$DOTFILES" --type f --hidden -E .git -E '*.bak' | rofi \
    -dmenu -i -no-custom \
    -sort -sorting-method fzf \
    -theme-str 'window { width: 600px; } entry { placeholder: "config file"; }' \
    -config "$HOME/.config/rofi/minimal.rasi")
[[ -z "$file" ]] && exit

ghostty -e nvim "$DOTFILES/$file"
