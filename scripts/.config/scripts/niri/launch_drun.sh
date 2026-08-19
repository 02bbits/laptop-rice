#!/bin/bash

# Enter prefered dmenu
menu=rofi

if pgrep -x $menu; then
    pkill $menu
else
    # $menu
    # for rofi
    rofi -show drun -sorting-method fzf -sort -config $HOME/.config/rofi/minimal.rasi
fi
