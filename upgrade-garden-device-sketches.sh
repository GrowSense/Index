#!/bin/bash

DEVICES_DIR="devices"

DIR=$PWD

echo ""
echo "Upgrading devices..."
echo ""

if [ -d "$DEVICES_DIR" ]; then
    for d in $DEVICES_DIR/*; do
        DEVICE_NAME=$(cat $d/name.txt)
        DEVICE_LABEL=$(cat $d/label.txt)        
        
        echo "$DEVICE_LABEL"
        
        sh upgrade-garden-device-sketch.sh $DEVICE_NAME || echo "Failed to upgrade device sketch"
       
        echo ""
    done
else
    echo "No devices have been added."
fi

echo ""
