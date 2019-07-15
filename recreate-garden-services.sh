DEVICES_DIR="devices"

DIR=$PWD

echo "Recreating device services..."

if [ -d "$DEVICES_DIR" ]; then
    for d in $DEVICES_DIR/*; do
    
      if [ -f $d/name.txt ]; then
      
        DEVICE_GROUP=$(cat $d/group.txt)
        echo "  Device group: $DEVICE_GROUP"
        
        echo "Found device info:"
        echo $d
        DEVICE_NAME=$(cat $d/name.txt)
        echo "  Device name: $DEVICE_NAME"
        DEVICE_LABEL=$(cat $d/label.txt)
        echo "  Device label: $DEVICE_LABEL"
        DEVICE_PORT=$(cat $d/port.txt)
        echo "  Device port: $DEVICE_PORT"
        DEVICE_BOARD=$(cat $d/board.txt)
        echo "  Device board: $DEVICE_BOARD"

        if [ "$DEVICE_BOARD" = "esp" ]; then
          echo "ESP/WiFi device. No services need to be created."     
        elif [ "$DEVICE_GROUP" = "ui" ]; then
          echo "Recreating UI controller service..."
          sh create-ui-controller-1602-service.sh $DEVICE_NAME $DEVICE_PORT || (echo "Failed to recreate UI controller service for: $DEVICE_NAME" && exit 1)
        else
          echo "Recreating MQTT bridge service..."
          sh create-mqtt-bridge-service.sh $DEVICE_GROUP $DEVICE_NAME $DEVICE_PORT || (echo "Failed to recreate MQTT bridge service for: $DEVICE_NAME" && exit 1)
        fi
      fi
    done
else
    echo "No device info found in $DEVICES_DIR"
fi
