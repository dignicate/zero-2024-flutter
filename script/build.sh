#!/bin/bash

echo "=== Dignicate, zero 2024 development environment ==="
echo
echo "Switch environment"
echo "  1 -> Product"
echo "  2 -> Staging"
echo "  3 -> Dev"
echo
echo
read -rp "Select environment: " input

if [ "$input" = 1 ]; then
  echo "Product"
  ENV="prod"
elif [ "$input" = 2 ]; then
  echo "Staging"
  ENV="stg"
elif [ "$input" = 3 ]; then
  echo "Dev"
  ENV="dev"
else
  echo "Cancel"
  exit
fi

echo
read -rp "Clean? (y/N) [N]: " input

if [ "$input" = "y" ]; then
  flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs
  if [ $? -eq 0 ]; then
    echo "Build success."
  else
    echo "Build failed."
    exit
  fi
fi

echo
echo "====================="
echo "Create package"
echo "  11 -> Android (aab)"
echo "  12 -> Android (apk)"
echo "  21 -> iOS"
echo "  22 -> iOS (ad-hoc)"
echo "  else -> Run on device or emulator"
echo
echo
read -rp "Select: " input

if [ "$input" = 11 ]; then
  echo "Android (aab)"
  flutter build appbundle --dart-define=ENV=$ENV
elif [ "$input" = 12 ]; then
  echo "Android (apk, debug)"
  flutter build apk --debug --dart-define=ENV=$ENV
elif [ "$input" = 21 ]; then
  echo "iOS (release or testflight)"
  flutter build ipa --dart-define=ENV=$ENV
elif [ "$input" = 22 ]; then
  echo "iOS (ad-hoc)"
  flutter build ipa --export-method=ad-hoc --dart-define=ENV=$ENV
else
  echo "Run on device or emulator"
  device_ids=$(flutter devices | grep -E 'android|ios' | awk -F' • ' '{print $2}')
  if [ -z "$device_ids" ]; then
    echo "Mobile device not found."
  else
    echo "To run flutter:"
    for id in $device_ids; do
      echo "> flutter run -d $id --dart-define=ENV=$ENV"
    done
  fi
  exit
fi

