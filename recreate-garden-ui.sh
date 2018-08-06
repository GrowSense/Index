DEVICES_DIR="devices"

DIR=$PWD

echo "Resetting linear MQTT UI"
cd mobile/linearmqtt/
sh reset.sh
cd $DIR

echo "Recreating linear MQTT UI"
if [ -d "$DEVICES_DIR" ]; then
    for d in "$DEVICES_DIR/*"; do
        echo "Found device info:"
        echo $d
        DEVICE_TYPE=$(cat $d/type.txt)
        echo "  Device type: $DEVICE_TYPE"
        DEVICE_NAME=$(cat $d/name.txt)
        echo "  Device name: $DEVICE_NAME"
        DEVICE_LABEL=$(cat $d/label.txt)
        echo "  Device label: $DEVICE_LABEL"
        
        SHORT_TYPE="$(dirname $DEVICE_TYPE)"
        echo "  Short type: $SHORT_TYPE"
        if [ "$SHORT_TYPE" = "monitor" ]; then
            echo "  Monitor device"
            sh create-garden-monitor-ui.sh $DEVICE_LABEL $DEVICE_NAME
        else
            echo "  Irrigator device"
            sh create-garden-irrigator-ui.sh $DEVICE_LABEL $DEVICE_NAME
        fi
    done
else
    echo "No device info found in $DEVICES_DIR"
fi
