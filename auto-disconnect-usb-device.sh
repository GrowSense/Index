#!/bin/bash


DEVICE_PORT=$1

EXAMPLE="Example:\n\tauto-disconnect-device.sh [Port]"

if [ ! $DEVICE_PORT ]; then
  echo "Please provide a port as an argument."
  echo $EXAMPLE
  exit 1
fi

echo "Automatically disconnecting device..."

echo "Device port: $DEVICE_PORT"

#sh update.sh

echo "Looking for device:"

DEVICES_DIR="devices"

DEVICE_NAME=""

HOST=$(cat /etc/hostname)

if [ -d $DEVICES_DIR ]; then
  for d in $DEVICES_DIR/*
  do
    echo "Device info dir: $d"

    PORT=$(cat "$d/port.txt")

    echo "Port: $PORT"

    if [ "$PORT" = "$DEVICE_PORT" ] && [ "$HOST" == "$(cat "$d/host.txt")" ]; then
      DEVICE_NAME=$(cat "$d/name.txt")
      DEVICE_LABEL=$(cat "$d/label.txt")
    fi
  done
fi

# Disabled because it's causing problems with tests
#notify-send "Removing $DEVICE_NAME device"


if [ $DEVICE_NAME ]; then
  bash run-background.sh bash mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Disconnecting" "-r"

  bash create-alert-file.sh "$DEVICE_LABEL disconnecting"

  echo "Device name: $DEVICE_NAME"

  echo "Stopping device services..."
  sh stop-garden-device.sh $DEVICE_NAME

  SCRIPT_NAME="disconnect-garden-device.sh"
  echo ""
  echo "Remove device script:"
  echo $SCRIPT_NAME "$DEVICE_NAME"
  echo ""
  sh $SCRIPT_NAME "$DEVICE_NAME" || exit 1

  bash run-background.sh bash mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Disconnected" "-r"

  bash create-alert-file.sh "$DEVICE_LABEL disconnected"

  bash send-email.sh "Device $DEVICE_LABEL disconnected via USB (on $HOST)." "The $DEVICE_LABEL device was disconnected via USB on host $HOST."

  echo "Finished auto disconnecting device."
else
  echo "Device not found."
fi

# Disabled because it's causing problems with tests
#notify-send "Finished removing $DEVICE_NAME device"
