#!/bin/bash

BATTERY_LEVEL=$(cat /sys/class/power_supply/BATT/capacity)
STATUS=$(cat /sys/class/power_supply/BATT/status)

if [[ "$BATTERY_LEVEL" -le 20 && "$STATUS" == "Discharging" ]]; then
    notify-send -u critical "Battery Low" "Battery level is at $BATTERY_LEVEL%!"
fi

if [[ "$BATTERY_LEVEL" -ge 80 && "$STATUS" == "Charging" ]]; then
    notify-send -u normal "Battery Full" "Battery level is at $BATTERY_LEVEL%, consider unplugging."
fi

