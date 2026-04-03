#!/usr/bin/env bash
# Alpine Dusk — gtklock wrapper
# Uses pre-blurred wallpaper and cached status info for instant lock.

set -euo pipefail

WALLPAPER="$HOME/.local/share/wallpapers/wallpaper.jpg"
BLURRED="/tmp/lockscreen-blurred.jpg"

# ---- Ensure blurred wallpaper exists (should be pre-generated at login) ----
if [ ! -f "$BLURRED" ]; then
    magick "$WALLPAPER" -blur 0x12 -brightness-contrast -30x0 "$BLURRED"
fi

# ---- Gather status info (fast only, no network calls) ----
battery=""
if [ -d /sys/class/power_supply/BAT0 ]; then
    pct=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "")
    [ -n "$pct" ] && battery="${pct}%"
fi

wifi=""
if command -v nmcli &>/dev/null; then
    wifi=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2 | head -1) || true
fi

# Read cached weather from waybar's weather script (no curl needed)
weather=""
if [ -f /tmp/waybar-weather-cache ]; then
    weather=$(cat /tmp/waybar-weather-cache 2>/dev/null || echo "")
fi

# ---- Build date format with status ----
status_parts=()
[ -n "$wifi" ]    && status_parts+=("$wifi")
[ -n "$battery" ] && status_parts+=("$battery")
[ -n "$weather" ] && status_parts+=("$weather")

date_fmt="%A, %d %b"
if [ ${#status_parts[@]} -gt 0 ]; then
    status_line=$(IFS=" · "; echo "${status_parts[*]}")
    date_fmt="${date_fmt}  ·  ${status_line}"
fi

exec gtklock -d -b "$BLURRED" --date-format "$date_fmt"
