#!/usr/bin/env bash

echo "1. Sunshine on 47989 for huawei"
echo "2. Sunshine on 48989 for lenovo"
echo "3. Sunshine on 49989 for remote"
read -r -p "Enter numbers: " input

tokens=$(printf '%s\n' "$input" | tr ',' ' ' | tr -s ' ' '\n')

run_any=false

if printf '%s\n' "$tokens" | grep -qx "1"; then
  sunshine .config/sunshine/sunshine.conf &
  run_any=true
fi

if printf '%s\n' "$tokens" | grep -qx "2"; then
  sunshine .config/sunshine/sunshine-alt.conf &
  run_any=true
fi

if printf '%s\n' "$tokens" | grep -qx "3"; then
  sunshine .config/sunshine/sunshine-remote.conf &
  systemctl start tailscaled sshd
  run_any=true
fi

if ! $run_any; then
  echo "No valid choice entered."
  exit 1
fi
