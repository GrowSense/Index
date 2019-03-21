#!/bin/bash


DEVICE_PORT=$1

EXAMPLE="Example:\n\t...sh [Port]"

if [ ! $DEVICE_PORT ]; then
  echo "Provide a port as an argument."
  echo $EXAMPLE
  exit 1
fi

echo "Automatically removing device..."

echo "Device port: $DEVICE_PORT"

sh update.sh

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
  echo "Device name: $DEVICE_NAME"


  SCRIPT_NAME="remove-garden-device.sh"
  echo ""
  echo "Remove device script:"
  echo $SCRIPT_NAME "$DEVICE_NAME"
  echo ""
  sh $SCRIPT_NAME "$DEVICE_NAME"

else
  echo "Device not found."
fi

# Disabled because it's causing problems with tests
#notify-send "Finished removing $DEVICE_NAME device"
