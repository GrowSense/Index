DEVICE_NAME=$1

DEVICE_INFO_DIR="devices/$DEVICE_NAME"

echo "Marking the device as having a UI created..."
echo "Device name: $DEVICE_NAME"

mkdir -p "$DEVICE_INFO_DIR" && \
  
echo "1" > "$DEVICE_INFO_DIR/is-ui-created.txt"
