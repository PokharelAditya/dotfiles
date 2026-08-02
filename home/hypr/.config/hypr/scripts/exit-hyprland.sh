#!/bin/bash

confirm=$(printf "No\nYes" | rofi -dmenu -i -p "Exit hyprland?")

if [[ "$confirm" == "Yes" ]]; then
  loginctl kill-session $XDG_SESSION_ID
fi

