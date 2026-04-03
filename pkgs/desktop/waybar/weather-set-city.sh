#!/usr/bin/env bash
# Pick a new weather city via fuzzel and signal waybar to refresh

CITY_FILE="$HOME/.config/waybar/weather-city"
CURRENT=$(cat "$CITY_FILE" 2>/dev/null || echo "London")

NEW_CITY=$(echo "$CURRENT" | fuzzel --dmenu --prompt="  City: " --width=28 --lines=0)

[[ -z "$NEW_CITY" ]] && exit 0

mkdir -p "$(dirname "$CITY_FILE")"
echo "$NEW_CITY" > "$CITY_FILE"
pkill -RTMIN+8 waybar
