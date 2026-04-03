#!/usr/bin/env bash
# Weather module for waybar — reads city from ~/.config/waybar/weather-city

CITY_FILE="$HOME/.config/waybar/weather-city"
CITY=$(cat "$CITY_FILE" 2>/dev/null || echo "London")

OUTPUT=$(wttrbar --location "$CITY" --main-indicator temp_C --custom-indicator '{ICON} {temp_C}°')

# Cache a plain-text version for the lockscreen
echo "$OUTPUT" | jq -r '.text // empty' > /tmp/waybar-weather-cache 2>/dev/null || true

echo "$OUTPUT"
