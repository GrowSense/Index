echo ""
echo "Disconnecting garden device..."
echo ""

DEVICE_NAME=$1

BOARD_TYPE=$(cat "devices/$DEVICE_NAME/board.txt")

if [ ! $DEVICE_NAME ]; then
  echo "Error: Specify a device name as an argument."
  exit 1
else
  echo "  Device name: $DEVICE_NAME"
  echo "  Board type: $BOARD_TYPE"

  sh remove-garden-device-services.sh $DEVICE_NAME || exit 1

  DEVICE_INFO_DIR="devices/$DEVICE_NAME"

  echo "  Marking device as disconnected from USB"
  echo "0" > "$DEVICE_INFO_DIR/is-usb-connected.txt"

  echo "Finished disconnecting device: $DEVICE_NAME"
fi
