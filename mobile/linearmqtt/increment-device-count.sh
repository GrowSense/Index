#!/bin/sh

echo "Incrementing device count"

DEVICE_COUNT=0

if [ -f "devicecount.txt" ]; then
  echo "Getting device count from: devicecount.txt"
  DEVICE_COUNT=$(cat devicecount.txt)
else
  echo "No 'devicecount.txt' file found. Starting at 0."
fi

echo "Current count: $DEVICE_COUNT"

DEVICE_COUNT=$(($DEVICE_COUNT + 1))

echo "New count: $DEVICE_COUNT"

echo $DEVICE_COUNT > devicecount.txt
