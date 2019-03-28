#!/bin/bash

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
        
        sh supervise-device.sh $DEVICE_NAME
       
        echo ""
    done
else
    echo "No devices have been added."
fi

echo ""
