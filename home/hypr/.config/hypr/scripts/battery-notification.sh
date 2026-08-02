#!/bin/bash

while true; do
  # Get battery percentage
  battery=$(acpi -b | grep -P -o '[0-9]+(?=%)')

  # Threshold
  low=20

  if [ "$battery" -lt "$low" ]; then
      notify-send "Battery Low" "Battery is at ${battery}%!" -u critical
  fi

  sleep 240
done
