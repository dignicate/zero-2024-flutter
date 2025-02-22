#!/bin/bash

# This script provides a menu-driven interface for various Flutter development tasks.
# To use this script, you can set up an alias in your shell configuration file (e.g., .bashrc or .zshrc):
# ```
# alias opendg="bash <(curl -sSL https://raw.githubusercontent.com/dignicate/zero-2024-flutter/refs/heads/main/script/opendg.sh)"
# ```
# After setting up the alias, you can simply type `opendg` in your terminal to run this script.


OPTIONS_FILE="/tmp/opendg/run_options"
LAST_CMD_FILE="/tmp/opendg/last_cmd"
CURRENT_OPTION_FILE="/tmp/opendg/current_option"

mkdir -p /tmp/opendg

echo "=== Dignicate, zero OpenDG script. ==="
echo "  1. Git empty commit"
echo "  2. Run "
echo "  3. Set option"
echo "  4. Open iOS simulator"
echo "  5. Redo last command"
echo "Any other key to Exit"
echo
read -p "Select an option: " input

echo_eval() {
  local cmd="$1"
  echo "$cmd"
  read -p "Choose (c)opy or (r)un the command. [c/r] (default: r): " choice
  choice=${choice:-r}
  if [ "$choice" = "c" ]; then
    echo "$cmd" | pbcopy
    echo "Command copied to clipboard."
  else
    echo "$cmd" > "$LAST_CMD_FILE"
    eval "$cmd"
  fi
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
  local os_version=""
  xcrun simctl list devices | while read -r line; do
    if [[ "$line" =~ ^-- ]]; then
      os_version=$(echo "$line" | sed 's/-- \(.*\) --/\1/')
    elif [[ "$line" =~ \([A-F0-9-]{36}\) ]]; then
      device_name=$(echo "$line" | awk -F' \\(' '{print $1}' | xargs)
      device_id=$(echo "$line" | grep -oE '[A-F0-9-]{36}')
      if [[ -z "$keyword" || "$device_name" == *"$keyword"* ]]; then
        echo "$device_id, $device_name, $os_version"
      fi
    fi
  done
}

set_option() {
  if [ -f "$OPTIONS_FILE" ]; then
    current_options=$(<"$OPTIONS_FILE")
    echo "Current options: "
    echo "$current_options"
  else
    echo "No options set."
  fi

  # shellcheck disable=SC2001
  echo "Choose an action:"
  echo "  1. List current options"
  echo "  2. Add new option"
  echo "  3. Delete an option"
  echo "  4. Cancel"
  read -p "Select an action: " action

  case $action in
    1)
      if [ -f "$OPTIONS_FILE" ]; then
        # shellcheck disable=SC2207
        options=($(<"$OPTIONS_FILE"))
        list_options
        read -p "Select an option to set as current: " select_index
        if [[ $select_index -gt 0 && $select_index -le ${#options[@]} ]]; then
          selected_option=${options[$((select_index-1))]}
          echo "$selected_option" > "$CURRENT_OPTION_FILE"
          echo "Current option set to: $selected_option"
        else
          echo "Invalid selection."
        fi
      else
        echo "No options set."
      fi
      ;;
    2)
      read -p "Enter additional arguments (e.g., --dart-define=XXXX): " additional_args
      if [ -n "$additional_args" ]; then
        echo "$additional_args" >> "$OPTIONS_FILE"
        echo "Option added."
        list_options
      else
        echo "No option added."
      fi
      ;;
    3)
      if [ -f "$OPTIONS_FILE" ]; then
        # shellcheck disable=SC2207
        options=($(<"$OPTIONS_FILE"))
        list_options
        read -p "Select an option to delete: " delete_index
        if [[ $delete_index -gt 0 && $delete_index -le ${#options[@]} ]]; then
          # shellcheck disable=SC2184
          unset options[$((delete_index-1))]
          printf "%s\n" "${options[@]}" > "$OPTIONS_FILE"
          echo "Option deleted."
          if [ "${#options[@]}" -gt 0 ]; then
            selected_option=${options[0]}
            echo "$selected_option" > "$CURRENT_OPTION_FILE"
            echo "Current option set to: $selected_option"
          else
            # shellcheck disable=SC2188
            > "$CURRENT_OPTION_FILE"
          fi
          echo "Updated options:"
          # shellcheck disable=SC2207
          options=($(<"$OPTIONS_FILE"))
          list_options
        else
          echo "Invalid selection."
        fi
      else
        echo "No options set."
      fi
      ;;
    4)
      echo "Operation canceled."
      ;;
    *)
      echo "Invalid action."
      ;;
  esac
}

if [ "$input" = 1 ]; then
  echo_eval "git commit --allow-empty -m \"empty commit\""
elif [ "$input" = 2 ]; then
  if [ -f "$CURRENT_OPTION_FILE" ] && [ -s "$CURRENT_OPTION_FILE" ]; then
    additional_args=$(<"$CURRENT_OPTION_FILE")
  else
    if [ -f "$OPTIONS_FILE" ]; then
      # shellcheck disable=SC2207
      options=($(<"$OPTIONS_FILE"))
      if [ ${#options[@]} -gt 0 ]; then
        additional_args=${options[0]}
        echo "$additional_args" > "$CURRENT_OPTION_FILE"
      else
        additional_args=""
      fi
    else
      additional_args=""
    fi
  fi

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
  echo "devices: $devices"
  if [ -n "$devices" ]; then
    echo "Available iOS devices:"
    echo "$devices" | nl -w 2 -s '. '
    echo
    read -p "Select a device: " device_index
    device_id=$(echo "$devices" | sed -n "${device_index}p" | awk -F', ' '{print $1}')
    if [ -n "$device_id" ]; then
      xcrun simctl boot "$device_id"
      echo_eval "open -a Simulator --args -CurrentDeviceUDID \"$device_id\""
    else
      echo "Invalid selection."
    fi
  else
    echo "No iOS device found."
  fi
elif [ "$input" = 5 ]; then
    if [ -f "$LAST_CMD_FILE" ]; then
      last_cmd=$(<"$LAST_CMD_FILE")
      echo_eval "$last_cmd"
    else
      echo "No command to redo."
    fi
else
  echo "Exit"
  exit
fi
