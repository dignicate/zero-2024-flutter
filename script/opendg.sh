#!/bin/bash

# This script provides a menu-driven interface for various Flutter development tasks.
# To use this script, you can set up an alias in your shell configuration file (e.g., .bashrc or .zshrc):
# ```
# alias opendg="bash <(curl -sSL https://raw.githubusercontent.com/dignicate/zero-2024-flutter/refs/heads/main/script/opendg.sh)"
# ```
# After setting up the alias, you can simply type `opendg` in your terminal to run this script.


OPTIONS_FILE="$HOME/.flutter_run_options"

echo "=== Dignicate, zero OpenDG script. ==="
echo "  1. Git empty commit"
echo "  2. Run "
echo "  3. Set option"
echo "  4. Open iOS simulator"
echo "Any other key to Exit"
echo
read -p "Select an option: " input

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

list_ios_simulators() {
  local keyword="$1"
  xcrun simctl list devices | grep -E 'iPhone|iPad' | grep -v 'unavailable' | while read -r line; do
    device_name=$(echo "$line" | awk -F' \\(' '{print $1}')
    device_id=$(echo "$line" | grep -oE '[A-F0-9-]{36}')
    if [[ "$device_name" == *"$keyword"* ]]; then
      echo "$device_id, $device_name"
    fi
  done
}

set_option() {
  if [ -f "$OPTIONS_FILE" ]; then
    current_options=$(<"$OPTIONS_FILE")
    echo "Current options: $current_options"
  else
    echo "No options set."
  fi

  read -p "Enter additional arguments (e.g., --dart-define=XXXX) or press Enter to cancel: " additional_args

  if [ -n "$additional_args" ]; then
    echo "$additional_args" > "$OPTIONS_FILE"
    echo "Options saved."
  else
    echo "Operation canceled."
  fi
}

if [ "$input" = 1 ]; then
  echo_eval "git commit --allow-empty -m \"empty commit\""
elif [ "$input" = 2 ]; then
  read -r additional_args < "$OPTIONS_FILE"

  echo "Fetching device information, please wait..."
  echo

  devices=$(parse_devices)

  if [ -n "$devices" ]; then
    echo "Available devices:"
    echo "$devices" | nl -w 2 -s '. '
    echo
    read -p "Select a device: " device_index
    device_id=$(echo "$devices" | sed -n "${device_index}p" | awk -F', ' '{print $1}')
    if [ -n "$device_id" ]; then
      cmd="fvm flutter run -d $device_id $additional_args"
      echo_eval "$cmd"
    else
      echo "Invalid selection."
    fi
  else
    echo "No device found."
  fi
elif [ "$input" = 3 ]; then
  set_option
  # Add your set option code here
elif [ "$input" = 4 ]; then
  echo "Fetching iOS devices, please wait..."
  echo
  read -p "Enter keyword to filter devices (e.g., iPhone, iPad): " keyword
  devices=$(list_ios_simulators "$keyword")
  if [ -n "$devices" ]; then
    echo "Available iOS devices:"
    echo "$devices" | nl -w 2 -s '. '
    echo
    read -p "Select a device: " device_index
    device_id=$(echo "$devices" | sed -n "${device_index}p" | awk -F', ' '{print $1}')
    if [ -n "$device_id" ]; then
      xcrun simctl boot "$device_id"
      open -a Simulator --args -CurrentDeviceUDID "$device_id"
    else
      echo "Invalid selection."
    fi
  else
    echo "No iOS device found."
  fi
else
  echo "Exit"
  exit
fi
