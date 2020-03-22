echo ""
echo "Starting all garden services"
echo ""

DIR=$PWD

sh start-mesh-manager.sh || exit 1

sh start-supervisor.sh || exit 1

DEVICES_DIR="devices"

CURRENT_HOST="$(cat /etc/hostname)"

if [ -d "$DEVICES_DIR" ]; then
    for d in $DEVICES_DIR/*; do
        if [ -d $d ]; then
            DEVICE_NAME=$(cat $d/name.txt)
            DEVICE_LABEL=$(cat $d/label.txt)
            DEVICE_HOST=$(cat $d/host.txt)
            DEVICE_IS_USB_CONNECTED=$(cat $d/is-usb-connected.txt)

            echo "$DEVICE_LABEL"
            echo "  Name: $DEVICE_NAME"
            echo "  Host: $DEVICE_HOST"
            echo "  Current host: $CURRENT_HOST"

            if [ "$DEVICE_HOST" != "$CURRENT_HOST" ]; then
                echo "  Device $DEVICE_NAME is on another host. Skipping start service..."
            elif [ "$DEVICE_IS_USB_CONNECTED" = "0" ]; then
                echo "  Device $DEVICE_NAME is not connected via USB. Skipping start service..."
            else
                bash start-garden-device.sh $DEVICE_NAME
            fi

            echo ""
        fi
    done
else
    echo "No device info found in $DEVICES_DIR"
fi
