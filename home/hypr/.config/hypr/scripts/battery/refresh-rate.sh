#!/usr/bin/env bash

FILE="$HOME/.config/hypr/conf/eDP.lua"
POWER="/sys/class/power_supply/ACAD/online"

LAST=""

while true; do
    AC=$(cat "$POWER" 2>/dev/null)

    if [[ -n "$AC" && "$AC" != "$LAST" ]]; then
        if [[ "$AC" == "0" ]]; then
            RATE=60
        else
            RATE=144
        fi

        sed -i -E "s/^(local refreshRate = )[0-9.]+/\1${RATE}/" "$FILE"
        LAST="$AC"
    fi

    sleep 10
done
