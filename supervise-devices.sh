#!/bin/bash

LOOP_NUMBER=$1

if [ ! $LOOP_NUMBER ]; then
  echo "Please provide a loop number as an argument."
  exit 1
fi

DEVICES_DIR="devices"

DIR=$PWD

echo ""
echo "Supervising garden devices..."
echo ""

if [ -d "$DEVICES_DIR" ]; then
    for d in $DEVICES_DIR/*; do
        DEVICE_NAME=$(cat $d/name.txt)
        DEVICE_LABEL=$(cat $d/label.txt)        
        
        echo "$DEVICE_LABEL"
        
        sh supervise-device.sh $LOOP_NUMBER $DEVICE_NAME
       
        echo ""
    done
else
    echo "No devices have been added."
fi

echo "Finished supervising garden devices..."

echo ""
