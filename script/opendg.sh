#!/bin/bash

OPTIONS_FILE="$HOME/.flutter_run_options"

echo "=== Dignicate, zero OpenDG script. ==="
echo "  1. Git empty commit"
echo "  2. Run "
echo "  3. Set option"
echo "  4. Open iOS simulator"
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

list_ios_simulators() {
  local keyword="$1"
  xcrun simctl list devices | grep -E 'iPhone|iPad' | grep -v 'unavailable' | while read -r line; do
    device_name=$(echo "$line" | awk -F' \\(' '{print $1}')
    device_id=$(echo "$line" | awk -F'\\(' '{print $2}' | awk -F'\\)' '{print $1}')
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

  read -rp "Enter additional arguments (e.g., --dart-define=XXXX) or press Enter to cancel: " additional_args

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
#  echo "Select platform:"
#  echo "  1 -> Android"
#  echo "  2 -> iOS"
#  echo "  Any other key -> Both"
#  read -n 1 -rp "Select an option: " platform
#  echo

  echo "Fetching device information, please wait..."
  echo

#  if [ "$platform" = 1 ]; then
#    devices=$(parse_devices | grep android)
#  elif [ "$platform" = 2 ]; then
#    devices=$(parse_devices | grep ios)
#  else
    devices=$(parse_devices)
#  fi

  if [ -n "$devices" ]; then
    echo "Available devices:"
    echo "$devices" | nl -w 2 -s '. '
    echo
    read -n 1 -rp "Select a device: " device_index
    echo
    device_id=$(echo "$devices" | sed -n "${device_index}p" | awk -F', ' '{print $1}')
    if [ -n "$device_id" ]; then
#      echo_eval "flutter run -d $device_id"
      cmd="flutter run -d $device_id $additional_args"
      echo "$cmd"
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
  read -rp "Enter keyword to filter devices (e.g., iPhone, iPad): " keyword
  devices=$(list_ios_simulators "$keyword")
  if [ -n "$devices" ]; then
    echo "Available iOS devices:"
    echo "$devices" | nl -w 2 -s '. ' | head -n 9
    echo
    read -n 1 -rp "Select a device: " device_index
    echo
    device_id=$(echo "$devices" | sed -n "${device_index}p" | awk -F', ' '{print $1}')
    if [ -n "$device_id" ]; then
      if pgrep -x "Simulator" > /dev/null; then
        read -n 1 -rp "Simulator is already running. Close it? (y/N): " close_sim
        echo
        if [ "$close_sim" = "y" ]; then
          pkill -x "Simulator"
          open -a Simulator --args -CurrentDeviceUDID "$device_id"
        else
          echo "Operation canceled."
          exit
        fi
      else
        open -a Simulator --args -CurrentDeviceUDID "$device_id"
      fi
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
