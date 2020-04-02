echo "Recreating garden services..."

DEVICES_DIR="devices"

DIR=$PWD

echo ""
echo "  Stopping supervisor to avoid unnecessary error reports..."
bash stop-supervisor.sh || exit 1

echo ""
echo "  Recreating mesh manager service..."
bash create-mesh-manager-service.sh || exit 1

echo ""
echo "  Recreating WWW service..."
bash create-www-service.sh || exit 1

echo ""
echo "  Recreating network setup service..."
bash create-network-setup-service.sh || exit 1

echo ""
echo "  Recreating MQTT service..."
bash restart-mqtt-service.sh || exit 1

CURRENT_HOST=$(cat /etc/hostname)

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
        DEVICE_HOST=$(cat $d/host.txt)
        echo "  Device host: $DEVICE_HOST"
        DEVICE_IS_USB_CONNECTED=1
        if [ -f "$d/is-usb-connected.txt" ]; then
           DEVICE_IS_USB_CONNECTED=$(cat $d/is-usb-connected.txt)
        fi
        echo "  Device is connected via USB: $DEVICE_IS_USB_CONNECTED"

        if [ "$DEVICE_HOST" != "$CURRENT_HOST" ]; then
          echo "  Device is on another host. Skipping service creation...."
        elif [ "$DEVICE_IS_USB_CONNECTED" == "0" ]; then
          echo "  Device is not connected via USB. Skipping service creation..."
        else
          echo "  Device is connected via USB to the current host. Recreating service..."
          if [ "$DEVICE_BOARD" = "esp" ]; then
            echo "ESP/WiFi device. No services need to be created."
          elif [ "$DEVICE_GROUP" = "ui" ]; then
            echo "Recreating UI controller service..."
            sh create-ui-controller-1602-service.sh $DEVICE_NAME $DEVICE_PORT || exit 1
          else
            echo "Recreating MQTT bridge service..."
            sh create-mqtt-bridge-service.sh $DEVICE_GROUP $DEVICE_NAME $DEVICE_PORT || exit 1
          fi
        fi
      fi
    done
else
    echo "No device info found in $DEVICES_DIR"
fi

echo ""
echo "  Recreating supervisor service..."
bash create-supervisor-service.sh || exit 1

echo ""
echo "  Recreating upgrade service..."
bash create-upgrade-service.sh || exit 1

SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
    SUDO='sudo'
fi

echo ""
echo "  Reloading systemctl daemon..."
$SUDO systemctl daemon-reload

echo "Finished recreating garden services."
