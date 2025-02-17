#!/bin/bash

echo "=== Dignicate, zero OpenDG script. ==="
echo "  1. Git empty commit"
echo "  2. Show devices"
echo "Any other key to Exit"
echo
read -n 1 -rp "Select an option: " input
echo

echo_eval() {
  local cmd="$1"
  echo "$cmd"
  eval "$cmd"
}

parse_devices() {
  flutter devices | grep -E 'android|ios' | while read -r line; do
    device_id=$(echo "$line" | awk -F' • ' '{print $2}' | xargs)
    os_version=$(echo "$line" | awk -F' • ' '{print $4}')
    device_type=$(echo "$line" | grep -oE 'emulator|simulator|device')
    device_name=$(echo "$line" | awk -F' • ' '{print $1}')
    if [[ -z "$device_type" ]]; then
      device_type="Real Device"
    fi
    echo "$device_id, $os_version, $device_name"
  done
}

if [ "$input" = 1 ]; then
  echo "Git empty commit"
  echo_eval "git commit --allow-empty -m \"empty commit\""
elif [ "$input" = 2 ]; then
  echo "Show devices"
  echo "Select platform:"
  echo "  1 -> Android"
  echo "  2 -> iOS"
  echo "  Any other key -> Both"
  read -n 1 -rp "Select an option: " platform
  echo
  if [ "$platform" = 1 ]; then
    parse_devices | grep android
  elif [ "$platform" = 2 ]; then
    parse_devices | grep ios
  else
    parse_devices
  fi
else
  echo "Exit"
  exit
fi
