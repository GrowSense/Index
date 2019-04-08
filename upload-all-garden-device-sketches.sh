#!/bin/bash

DEVICES_DIR="devices"

DIR=$PWD

echo ""
echo "Garden devices..."
echo ""

if [ -d "$DEVICES_DIR" ]; then
    for d in $DEVICES_DIR/*; do
        DEVICE_NAME=$(cat $d/name.txt)
        DEVICE_LABEL=$(cat $d/label.txt) 
        DEVICE_GROUP=$(cat $d/group.txt)
        DEVICE_BOARD=$(cat $d/board.txt)
        DEVICE_PORT=$(cat $d/port.txt)
        
        echo "$DEVICE_LABEL"
        
        sh upload-$DEVICE_GROUP-$DEVICE_BOARD-sketch.sh $DEVICE_PORT
               
        echo ""
    done
else
    echo "No devices have been added."
fi

echo ""
