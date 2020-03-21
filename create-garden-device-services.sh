DEVICE_NAME=$1

echo "Creating garden device services..."

if [ ! $DEVICE_NAME ]; then
  echo "  Error: Please provide a device name as an argument."
  exit 1
fi

if [ ! -d "devices/$DEVICE_NAME" ]; then
  echo "  Error: Device '$DEVICE_NAME' not found."
  exit 1
fi

DEVICE_GROUP=$(cat "devices/$DEVICE_NAME/group.txt")
DEVICE_BOARD=$(cat "devices/$DEVICE_NAME/board.txt")
DEVICE_PORT=$(cat "devices/$DEVICE_NAME/port.txt")

if [ "$DEVICE_BOARD" == "esp" ]; then
  echo "  ESP/WiFi device. No services need to be created."
elif [ "$DEVICE_GROUP" == "ui" ]; then
  bash create-ui-controller-1602-service.sh $DEVICE_NAME $DEVICE_PORT || exit 1
else
  bash create-mqtt-bridge-service.sh $DEVICE_GROUP $DEVICE_NAME $DEVICE_PORT || exit 1
fi

echo ""
echo "  Reloading systemctl daemon..."
bash run-background.sh bash systemctl.sh daemon-reload || exit 1

echo "Finished creating garden device services."
