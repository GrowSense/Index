DEVICES_DIR="devices"

DIR=$PWD

echo ""
echo "Garden devices info..."
echo ""

if [ -d "$DEVICES_DIR" ]; then
    for d in $DEVICES_DIR/*; do
        DEVICE_GROUP=$(cat $d/group.txt)
        DEVICE_NAME=$(cat $d/name.txt)
        DEVICE_LABEL=$(cat $d/label.txt)
        DEVICE_PORT=$(cat $d/port.txt)
        DEVICE_HOST=$(cat $d/host.txt)
        DEVICE_BOARD=$(cat $d/board.txt)
        
        
        echo "$DEVICE_LABEL"
        echo "  Name: $DEVICE_NAME"
        echo "  Group: $DEVICE_GROUP"
        echo "  Port: $DEVICE_PORT"
        echo "  Board: $DEVICE_BOARD"
        echo "  Host: $DEVICE_HOST"
        
        sh check-garden-device.sh $DEVICE_NAME
       
        echo ""
    done
else
    echo "No device info found in $DEVICES_DIR"
fi

echo ""
