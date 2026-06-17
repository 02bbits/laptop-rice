#!/bin/bash

# Enter prefered dmenu
menu=fuzzel

if pgrep -x $menu; then
    pkill $menu
else
    $menu
    # for rofi
    # $menu -show drun -i
fi
