$DEVICE_NAME=$1

DEVICE_INFO_DIR="devices/$DEVICE_NAME"

mkdir -p "$DEVICE_INFO_DIR" && \
  
echo 1 > "$DEVICE_INFO_DIR/is-ui-created.txt"
