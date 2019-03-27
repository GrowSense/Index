DEVICES_DIR="devices"

DIR=$PWD

echo "Recreating device services..."

echo "Recreating linear MQTT UI"
if [ -d "$DEVICES_DIR" ]; then
    for d in $DEVICES_DIR/*; do
    
      if [ -f $d/name.txt ]; then
        echo "Found device info:"
        echo $d
        DEVICE_GROUP=$(cat $d/group.txt)
        echo "  Device group: $DEVICE_GROUP"
        DEVICE_NAME=$(cat $d/name.txt)
        echo "  Device name: $DEVICE_NAME"
        DEVICE_LABEL=$(cat $d/label.txt)
        echo "  Device label: $DEVICE_LABEL"
        DEVICE_PORT=$(cat $d/port.txt)
        echo "  Device port: $DEVICE_PORT"
        DEVICE_BOARD=$(cat $d/port.txt)
        echo "  Device board: $DEVICE_BOARD"
        
        sh create-mqtt-bridge-service.sh $DEVICE_GROUP $DEVICE_NAME $DEVICE_PORT || (echo "Failed to recreate MQTT bridge service for: $DEVICE_NAME" && exit 1)
              
        sh create-updater-service.sh $DEVICE_GROUP $DEVICE_NAME $DEVICE_PORT || (echo "Failed to recreate updater service for: $DEVICE_NAME" && exit 1)
      fi
    done
else
    echo "No device info found in $DEVICES_DIR"
fi
