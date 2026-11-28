#!/usr/bin/env bash

if [[ -d /sys/module/i2c_hid_acpi ]]; then
  sudo modprobe -r i2c_hid_acpi
else
  sudo modprobe i2c_hid_acpi
fi
