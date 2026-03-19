#!/bin/bash

BAT_NAME="BAT0"
CAPACITY=$(cat /sys/class/power_supply/$BAT_NAME/capacity)
STATUS=$(cat /sys/class/power_supply/$BAT_NAME/status)

ICON=""
COLOR="%{F#ffc600}"  # Primary color default

if [ "$STATUS" = "Charging" ]; then
    ICON=""
elif [ "$STATUS" = "Discharging" ]; then
    if [ "$CAPACITY" -le 20 ]; then
        ICON=""  # critical icon
        COLOR="%{F#ff6161}"  # alert color
    elif [ "$CAPACITY" -le 40 ]; then
        ICON=""
    elif [ "$CAPACITY" -le 60 ]; then
        ICON=""
    elif [ "$CAPACITY" -le 80 ]; then
        ICON=""
    else
        ICON=""
    fi
else
    ICON=""
fi

echo "${COLOR}${ICON} ${CAPACITY}%"
