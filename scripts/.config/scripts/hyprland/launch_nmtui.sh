#!/bin/bash

hyprctl dispatch exec '[float] ghostty -e "export NEWT_COLORS=$(<~/.config/nmtui/palette); nmtui"'
