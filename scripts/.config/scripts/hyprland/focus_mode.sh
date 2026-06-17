# Hyprland focus setup

hyprctl keyword animations:enabled 0 &&
    hyprctl keyword decoration:rounding 0 &&
    hyprctl keyword general:gaps_in 0 &&
    hyprctl keyword general:gaps_out 0 &&
    hyprctl keyword decoration:active_opacity 1 &&
    hyprctl keyword decoration:inactive_opacity 1 >/dev/null

# Open white noise
hyprctl dispatch exec '[workspace 5 silent; float; move center; size 500 500] vlc ~/White\ Noise\ 3\ Hour\ Long\ \[2y6zdAbN9o8\].mp4'
