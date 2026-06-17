#!/bin/bash
    
WORKSPACE_FILE="$HOME/.config/scripts/hyprland/data/workspaces.conf"

CHOICE=$(grep -oP '^\[\K[^\]]+' "$WORKSPACE_FILE" | rofi -dmenu -p "Select Workspace")

get_apps_for_workspace() {
    awk -v section="$workspace" '
        $0 ~ "\\[" section "\\]" { in_section=1; next }
        /^\[.*\]/ { in_section=0 }
        in_section && NF { print }
    ' "$WORKSPACE_FILE"
}

apps=$(get_apps_for_workspace)
echo $apps

while IFS= read -r app; do
    echo "Launching: $app"
    nohup $app >/dev/null 2>&1 &
done <<< "$apps"
