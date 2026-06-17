swayidle -w \
    timeout 300 'swaylock --screenshots \
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
    --ignore-empty-password
' \
    timeout 900 'hyprctl dispatch dpms off' resume 'sleep 1; hyprctl dispatch dpms on' \
    timeout 1200 'systemctl suspend -i' \
    before-sleep 'swaylock -f --grace 0 --screenshots \
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
    --ignore-empty-password
'
