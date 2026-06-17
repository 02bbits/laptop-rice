choose=$(echo -e "Zen Browser\nFirefox\nChromium" | rofi -dmenu -config browser_select.rasi)

if [ "$choose" = "Zen Browser" ]; then
    flatpak run app.zen_browser.zen
elif [ "$choose" = "Firefox" ]; then
    flatpak run org.mozilla.firefox
elif [ "$choose" = "Chromium" ]; then
    flatpak run io.github.ungoogled_software.ungoogled_chromium
fi
