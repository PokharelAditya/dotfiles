#!/bin/bash

# Pause animated wallpaper (mpvpaper)
# Usage: ./pause.sh

echo '{ "command": ["set_property", "pause", true] }' | socat - /tmp/mpv-socket

if [ $? -eq 0 ]; then
    echo "Wallpaper paused"
else
    echo "Error: Could not pause wallpaper (is mpvpaper running?)"
    notify-send -u critical --replace-id=5001 -a "Wallpaper" "Error" "Could not pause wallpaper"
    exit 1
fi
