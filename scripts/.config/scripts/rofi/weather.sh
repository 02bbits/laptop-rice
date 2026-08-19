#!/bin/bash

CACHE_FILE="/tmp/rofi_weather_cache"
CACHE_TTL=1800
SCRIPTS_DIR="$(dirname "$0")"

fetch_weather() {
    local city
    city=$(cat ~/.config/rofi/data/weather_city 2>/dev/null | tr ' ' '+')
    curl -sf "wttr.in/${city}?format=%l|%C|%t|%f|%h|%w|%p|%P" 2>/dev/null
}

# refresh or use cache
if [[ "$1" == "--refresh" ]] ||
    [[ ! -f "$CACHE_FILE" ]] ||
    (($(date +%s) - $(date -r "$CACHE_FILE" +%s) >= CACHE_TTL)); then
    weather_data=$(fetch_weather)
    [[ -n "$weather_data" ]] && echo "$weather_data" >"$CACHE_FILE"
else
    weather_data=$(cat "$CACHE_FILE")
fi

[[ -z "$weather_data" ]] && weather_data="unknown|Unavailable|--|--|--|--|--|--"

# parse
location=$(echo "$weather_data" | cut -d'|' -f1)
condition=$(echo "$weather_data" | cut -d'|' -f2)
temp=$(echo "$weather_data" | cut -d'|' -f3)
feels=$(echo "$weather_data" | cut -d'|' -f4)
humidity=$(echo "$weather_data" | cut -d'|' -f5)
wind=$(echo "$weather_data" | cut -d'|' -f6)
rain=$(echo "$weather_data" | cut -d'|' -f7)
pressure=$(echo "$weather_data" | cut -d'|' -f8)

case "${condition,,}" in
*sunny* | *clear*) icon="󰖙" ;;
*partly*cloud*) icon="󰖕" ;;
*cloud* | *overcast*) icon="" ;;
*rain* | *drizzle*) icon="" ;;
*thunder* | *storm*) icon="" ;;
*snow* | *blizzard*) icon="󰖘" ;;
*fog* | *mist*) icon="󰖑" ;;
*wind*) icon="" ;;
*) icon="" ;;
esac

# fetch 3-day forecast from wttr.in JSON
forecast_data=$(curl -sf "wttr.in/${location// /+}?format=j1" 2>/dev/null)

if [[ -n "$forecast_data" ]]; then
    day0_max=$(echo "$forecast_data" | python3 -c "import sys,json; d=json.load(sys.stdin)['weather']; print(d[0]['maxtempC']+'°C')" 2>/dev/null)
    day0_min=$(echo "$forecast_data" | python3 -c "import sys,json; d=json.load(sys.stdin)['weather']; print(d[0]['mintempC']+'°C')" 2>/dev/null)
    day1_date=$(echo "$forecast_data" | python3 -c "import sys,json; d=json.load(sys.stdin)['weather']; print(d[1]['date'])" 2>/dev/null)
    day1_desc=$(echo "$forecast_data" | python3 -c "import sys,json; d=json.load(sys.stdin)['weather']; print(d[1]['hourly'][4]['weatherDesc'][0]['value'])" 2>/dev/null)
    day1_max=$(echo "$forecast_data" | python3 -c "import sys,json; d=json.load(sys.stdin)['weather']; print(d[1]['maxtempC']+'°C')" 2>/dev/null)
    day1_min=$(echo "$forecast_data" | python3 -c "import sys,json; d=json.load(sys.stdin)['weather']; print(d[1]['mintempC']+'°C')" 2>/dev/null)
    day2_date=$(echo "$forecast_data" | python3 -c "import sys,json; d=json.load(sys.stdin)['weather']; print(d[2]['date'])" 2>/dev/null)
    day2_desc=$(echo "$forecast_data" | python3 -c "import sys,json; d=json.load(sys.stdin)['weather']; print(d[2]['hourly'][4]['weatherDesc'][0]['value'])" 2>/dev/null)
    day2_max=$(echo "$forecast_data" | python3 -c "import sys,json; d=json.load(sys.stdin)['weather']; print(d[2]['maxtempC']+'°C')" 2>/dev/null)
    day2_min=$(echo "$forecast_data" | python3 -c "import sys,json; d=json.load(sys.stdin)['weather']; print(d[2]['mintempC']+'°C')" 2>/dev/null)
fi

# ── build menu ─────────────────────────────────────────────
# prefix info lines with "##" — used below to silently ignore them

chosen=$(echo -en "󰑓 refresh
 open in terminal
                           \0nonselectable\x1ftrue
$icon $condition  $location\0nonselectable\x1ftrue
$temp\t\tfeels $feels\0nonselectable\x1ftrue
$humidity humidity    $wind\0nonselectable\x1ftrue
${rain}mm rain\t$pressure\0nonselectable\x1ftrue
TODAY\t\t↑$day0_max  ↓$day0_min\0nonselectable\x1ftrue" | rofi \
    -dmenu \
    -p "weather" \
    -config ~/.config/rofi/weather.rasi)

# $day1_date  $day1_desc  ↑$day1_max  ↓$day1_min\0nonselectable\x1ftrue
# $day2_date  $day2_desc  ↑$day2_max  ↓$day2_min\0nonselectable\x1ftrue

case "$chosen" in
*"refresh"*)
    bash "$0" --refresh
    ;;
*"open in terminal"*)
    ghostty -e bash -c "curl wttr.in/${location// /+}; read" &
    ;;
esac
