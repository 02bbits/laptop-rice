#!/bin/bash
# Session / power menu

option=$(echo -e "  Lock\n󰤄  Suspend\n󰍃  Logout\n  Reboot\n⏻  Shutdown" | rofi \
    -dmenu \
    -config "$HOME/.config/rofi/minimal_menu.rasi")

case "$option" in
*Lock*) swaylock -f ;;
*Suspend*) systemctl suspend ;;
*Logout*) niri msg action quit --skip-confirmation ;;
*Reboot*) systemctl reboot ;;
*Shutdown*) systemctl poweroff ;;
esac
