#!/bin/bash
# Act on the URL in the clipboard: open, play in mpv, or download with yt-dlp

url=$(wl-paste -n 2>/dev/null)
if [[ "$url" != http* ]]; then
    notify-send -u low "Link" "No URL in clipboard."
    exit 1
fi

option=$(echo -e "󰖟  Open in browser\n󰐊  Play in mpv\n󰕧  Download video\n󰎆  Download audio" | rofi \
    -dmenu \
    -mesg "$url" \
    -config "$HOME/.config/rofi/minimal-menu.rasi")

download() {
    notify-send -u low "Link" "Downloading $1…"
    if yt-dlp "${@:2}" "$url"; then
        notify-send -u low "Link" "Download finished."
    else
        notify-send -u critical "Link" "Download failed."
    fi
}

case "$option" in
*browser*) xdg-open "$url" ;;
*mpv*) mpv "$url" ;;
*video*) download video -o "$(xdg-user-dir VIDEOS)/%(title)s.%(ext)s" ;;
*audio*) download audio -x --audio-format mp3 -o "$(xdg-user-dir MUSIC)/%(title)s.%(ext)s" ;;
esac
