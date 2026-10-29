#!/usr/bin/env bash

MUX=$(asusctl armoury list 2>/dev/null \
  | awk '/^gpu_mux_mode:/ {f=1; next} f && /current:/ {print; exit}' \
  | grep -oP '\(\K[0-9]+(?=\))')

if [[ "$MUX" == "0" ]]; then
  asusctl aura effect static -c ff0000
  exit 0
fi

LAST_MODE=""
LAST_STATE=""

while true; do
  MODE=$(cardwire get 2>/dev/null | awk -F': ' '/^Current Mode:/ {print $2}')
  STATE=$(cardwire gpu --power 1 2>/dev/null)

  if [[ "$MODE" != "$LAST_MODE" || "$STATE" != "$LAST_STATE" ]]; then
    if [[ "$MODE" == "Integrated" && "$STATE" == "D3cold" ]]; then
      asusctl aura effect static -c 00ff00
    elif [[ "$MODE" == "Integrated" && "$STATE" != "D3cold" ]]; then
      asusctl aura effect static -c ffff00
    elif [[ "$MODE" != "Integrated" && "$STATE" == "D3cold" ]]; then
      asusctl aura effect static -c 00ffff
    else
      asusctl aura effect static -c ff00ff
    fi
    LAST_MODE="$MODE"
    LAST_STATE="$STATE"
  fi

  if [[ "$MODE" == "Integrated" ]]; then
    sleep 5
  else
    sleep 1
  fi
done
