#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for Monitor backlights (if supported) using brightnessctl

iDIR="$HOME/.config/dunst/icons"
notification_timeout=1000
step=10 # INCREASE/DECREASE BY THIS VALUE

# Get bus number
get_bus() {
    connector=$(niri msg focused-output | sed -n 's/.*(\([^)]*\)).*/\1/p' | head -n 1)
    ddcutil detect | awk -v conn="$connector" '
    /I2C bus/ { match($0, /i2c-([0-9]+)/, a); bus = a[1] }
    /DRM_connector/ && $0 ~ conn { print bus }
    '
}

# Get brightness
get_backlight() {
    ddcutil -b $(get_bus) getvcp 10 --noverify --sleep-multiplier 0.1 | grep -oP 'current value =\s*\K\d+'
}

# Get icons
get_icon() {
    current=$(get_backlight)
    if [ "$current" -le "20" ]; then
        icon="$iDIR/brightness-3.svg"
    elif [ "$current" -le "60" ]; then
        icon="$iDIR/brightness-2.svg"
    else
        icon="$iDIR/brightness-1.svg"
    fi
}

# Notify
notify_user() {
    notify-send -e -h string:x-canonical-private-synchronous:brightness_notif -h int:value:$current -u low -i "$icon" "Brightness : $current%"
}

# Change brightness
change_backlight() {
    local current_brightness
    echo 1
    current_brightness=$(get_backlight)
    # Calculate new brightness
    if [[ "$1" == "+ ${step}" ]]; then
        new_brightness=$((current_brightness + step))
    elif [[ "$1" == "- ${step}" ]]; then
        new_brightness=$((current_brightness - step))
    fi

    # Ensure new brightness is within valid range
    if ((new_brightness < 5)); then
        new_brightness=0
    elif ((new_brightness > 100)); then
        new_brightness=100
    fi

    ddcutil -b $(get_bus) --disable-dynamic-sleep --noverify --noverify --sleep-multiplier 0.1 setvcp 10 "${new_brightness}"
    get_icon
    current=$new_brightness
    notify_user
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
