#!/bin/bash

hyprctl output create auto huaweiTab

# while ! hyprctl monitors | grep -q 'huaweiTab'; do
    # sleep 0.5
# done

# mpvpaper -o "no-audio loop-file=inf panscan=1.0 video-pan-x=-0.125 hwdec=auto input-ipc-server=/tmp/mpv-socket-huaweiTab" huaweiTab "$HOME/wallpapers/Videos/GTR-Silver.mp4" &
