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

if [ -d $DEVICES_DIR ]; then
  for d in $DEVICES_DIR/*
  do
    echo "Device info dir: $d"
     
    PORT=$(cat "$d/port.txt")
     
    echo "Port: $PORT"
     
    if [ "$PORT" = "$DEVICE_PORT" ]; then
      DEVICE_NAME=$(cat "$d/name.txt")
    fi
  done
fi

# Disabled because it's causing problems with tests
#notify-send "Removing $DEVICE_NAME device"

if [ $DEVICE_NAME ]; then
  sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Disconnecting"

  echo "Device name: $DEVICE_NAME"
  
  echo "Stopping device services..."
  sh stop-garden-device.sh $DEVICE_NAME

  SCRIPT_NAME="disconnect-garden-device.sh"
  echo ""
  echo "Remove device script:"
  echo $SCRIPT_NAME "$DEVICE_NAME"
  echo ""
  sh $SCRIPT_NAME "$DEVICE_NAME" || exit 1
  
  sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Disconnected"
  
  echo "Finished auto disconnecting device."
else
  echo "Device not found."
fi

# Disabled because it's causing problems with tests
#notify-send "Finished removing $DEVICE_NAME device"
