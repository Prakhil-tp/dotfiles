#!/bin/bash

LOG_FILE="/tmp/charger-debug.log"

echo "Script executed at $(date)" >> "$LOG_FILE"

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus  # Replace 1000 with your actual UID (check using `id -u`)

CHARGER_STATUS_FILE="/sys/class/power_supply/ACAD/online"
LAST_STATUS_FILE="/tmp/charger_last_status"

if [ ! -f "$CHARGER_STATUS_FILE" ]; then
    echo "Error: Charger status file not found!" >> "$LOG_FILE"
    exit 1
fi

CHARGER_STATUS=$(cat "$CHARGER_STATUS_FILE")
LAST_STATUS=$(cat "$LAST_STATUS_FILE" 2>/dev/null || echo "-1")

echo "Current status: $CHARGER_STATUS, Last status: $LAST_STATUS" >> "$LOG_FILE"

if [ "$CHARGER_STATUS" -ne "$LAST_STATUS" ]; then
    if [ "$CHARGER_STATUS" -eq 1 ]; then
        notify-send "Charger Connected" || echo "Failed to send notification" >> "$LOG_FILE"
    else
        notify-send "Charger Disconnected" || echo "Failed to send notification" >> "$LOG_FILE"
    fi
    echo "$CHARGER_STATUS" > "$LAST_STATUS_FILE"
fi

echo "Script completed successfully" >> "$LOG_FILE"
exit 0

