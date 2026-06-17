clients=$(hyprctl clients -j | jq -r '.[].address' | sed 's/^0x//')

while :; do
  sleep 0.2
  new_clients=$(hyprctl clients -j | jq -r '.[].address' | sed 's/^0x//')
    
  for client in $new_clients; do
    if ! grep -q "$client" <<<"$clients"; then
        active_id=$(hyprctl activewindow -j | jq -r '.address' | sed 's/^0x//')
        if [ "$client" != "$active_id" ]; then
            title=$(hyprctl clients -j | jq -r ".[] | select(.address==\"0x55d56309c1d0\") | .class")
            notify-send -t 2000 "New background window opened" -a "System" -u low
        fi
    fi
    done
  clients="$new_clients"
done
