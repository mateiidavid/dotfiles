#!/usr/bin/env bash
# Weather module for waybar — reads city from ~/.config/waybar/weather-city

CITY_FILE="$HOME/.config/waybar/weather-city"
CITY=$(cat "$CITY_FILE" 2>/dev/null || echo "London")

CACHE="$HOME/.cache/waybar-weather.json"

# Run wttrbar with a timeout to avoid blocking waybar
OUTPUT=$(timeout 5 wttrbar --location "$CITY" --main-indicator temp_C --custom-indicator '{ICON} {temp_C}°' 2>/dev/null)

if [ -n "$OUTPUT" ]; then
    echo "$OUTPUT" > "$CACHE"
    echo "$OUTPUT" | jq -r '.text // empty' > /tmp/waybar-weather-cache 2>/dev/null || true
else
    # Serve cached result if the request failed/timed out
    OUTPUT=$(cat "$CACHE" 2>/dev/null || echo '{"text": "…", "tooltip": "Weather unavailable"}')
fi

echo "$OUTPUT"
