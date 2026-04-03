#!/usr/bin/env bash
# Power menu using fuzzel — spawned from waybar

choice=$(printf " Lock\n Suspend\n Log Out\n Reboot\n Shutdown" \
    | fuzzel --dmenu --prompt="  " --width=20 --lines=5)

case "$choice" in
    *"Lock")     swaylock -f ;;
    *"Suspend")  systemctl suspend ;;
    *"Log Out")  niri msg action quit ;;
    *"Reboot")   systemctl reboot ;;
    *"Shutdown") systemctl poweroff ;;
esac
