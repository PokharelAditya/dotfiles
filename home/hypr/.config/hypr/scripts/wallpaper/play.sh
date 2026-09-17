#!/bin/bash

# Resume animated wallpaper (mpvpaper)
# Usage: ./play.sh

echo '{ "command": ["set_property", "pause", false] }' | socat - /tmp/mpv-socket

if [ $? -eq 0 ]; then
    echo "Wallpaper resumed"
else
    echo "Error: Could not resume wallpaper (is mpvpaper running?)"
    notify-send -u critical --replace-id=5001 -a "Wallpaper" "Error" "Could not resume wallpaper"
    exit 1
fi
