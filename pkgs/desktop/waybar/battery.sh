#!/usr/bin/env bash
# Dual battery waybar widget — internal (BAT0 24Wh) + external (BAT1 71Wh)

read_bat() {
    local bat=$1
    local cap=$(cat /sys/class/power_supply/"$bat"/capacity 2>/dev/null || echo 0)
    local status=$(cat /sys/class/power_supply/"$bat"/status 2>/dev/null || echo "Unknown")
    local power_now=$(cat /sys/class/power_supply/"$bat"/power_now 2>/dev/null || echo 0)
    local watts=$(awk "BEGIN {printf \"%.1f\", $power_now / 1000000}")
    echo "$cap|$status|$watts"
}

IFS='|' read -r cap0 status0 watts0 <<< "$(read_bat BAT0)"
IFS='|' read -r cap1 status1 watts1 <<< "$(read_bat BAT1)"

# Combined capacity weighted by design energy
combined=$(( (cap0 * 24 + cap1 * 71) / 95 ))

# Pick icon based on combined level
if [[ "$status0" == "Charging" || "$status1" == "Charging" ]]; then
    icon="󰂄"
elif (( combined <= 15 )); then
    icon="󰁺"
elif (( combined <= 30 )); then
    icon="󰁻"
elif (( combined <= 50 )); then
    icon="󰁼"
elif (( combined <= 70 )); then
    icon="󰁽"
else
    icon="󰁾"
fi

# CSS class for warning/critical states
class=""
if (( combined <= 15 )); then
    class="critical"
elif (( combined <= 30 )); then
    class="warning"
fi

tooltip="Internal 24Wh: ${cap0}% (${watts0}W) [${status0}]\nExternal 71Wh: ${cap1}% (${watts1}W) [${status1}]"

printf '{"text": "%s %d%%", "tooltip": "%s", "class": "%s"}\n' "$icon" "$combined" "$tooltip" "$class"
