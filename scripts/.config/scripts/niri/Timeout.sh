swayidle -w \
    timeout 180 'brightnessctl -s set 10%' resume 'brightnessctl -r' \
    timeout 300 'swaylock -f' \
    timeout 420 'niri msg action power-off-monitors' resume 'niri msg action power-on-monitors' \
    timeout 540 'systemctl suspend' \
    before-sleep 'swaylock --screenshots \
    --clock \
    --indicator \
    --indicator-radius 100 \
    --indicator-thickness 7 \
    --effect-blur 7x5 \
    --effect-vignette 0.5:0.5 \
    --no-unlock-indicator \
    --datestr '' \
    --timestr '%H:%M' \
    --font-size 33 \
    --ignore-empty-password'
