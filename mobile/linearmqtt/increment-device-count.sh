#!/bin/sh

echo "Incrementing device count"

DEVICE_COUNT=$(cat devicecount.txt)

echo "Current count: $DEVICE_COUNT"

DEVICE_COUNT=$(($DEVICE_COUNT + 1))

echo "New count: $DEVICE_COUNT"

echo $DEVICE_COUNT > devicecount.txt
