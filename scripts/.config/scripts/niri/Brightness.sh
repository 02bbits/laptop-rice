#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for Monitor backlights (if supported) using brightnessctl

iDIR="$HOME/.config/dunst/icons"
notification_timeout=700
step=10 # INCREASE/DECREASE BY THIS VALUE

# Get bus number
# get_bus() {
#     connector=$(niri msg focused-output | sed -n 's/.*(\([^)]*\)).*/\1/p' | head -n 1)
#     ddcutil detect | awk -v conn="$connector" '
#     /I2C bus/ { match($0, /i2c-([0-9]+)/, a); bus = a[1] }
#     /DRM_connector/ && $0 ~ conn { print bus }
#     '
# }

# Get icons
get_icon() {
    current=20
    if [ "$current" -le "20" ]; then
        icon="$iDIR/brightness-3.svg"
    elif [ "$current" -le "60" ]; then
        icon="$iDIR/brightness-2.svg"
    else
        icon="$iDIR/brightness-1.svg"
    fi
}

# Notify
# notify_user() {
#     notify-send -e -h string:x-canonical-private-synchronous:brightness_notif -h int:value:$current -u low -i "$icon" "Brightness : $current%"
# }

# Change brightness
change_backlight() {
    # isEDP=$(niri msg focused-output |sed -n 's/.*(\([^)]*\)).*/\1/p'|head -n 1|grep "eDP")
    # if [[ $isEDP -n ]]; then
    #     continue;
    # fi

    if [[ "$1" == "+ ${step}" ]]; then
        brightnessctl set "${step}"%+
        ddcutil --skip-ddc-checks --noverify -b 8 --sleep-multiplier 0.01 setvcp 10 + "${step}"
    elif [[ "$1" == "- ${step}" ]]; then
        brightnessctl set "${step}"%-
        ddcutil --skip-ddc-checks --noverify -b 8 --sleep-multiplier 0.01 setvcp 10 - "${step}"
    fi
    # get_icon
    # notify_user
}

# Execute accordingly
case "$1" in
"--get")
    get_backlight
    ;;
"--inc")
    change_backlight "+ ${step}"
    ;;
"--dec")
    change_backlight "- ${step}"
    ;;
*)
    get_backlight
    ;;
esac
