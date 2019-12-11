DEVICE_NAME=$1
DEVICE_BOARD=$2
DEVICE_GROUP=$3
SERIAL_PORT=$4

echo "Reporting device upload failed..."

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

echo "  Device name: $DEVICE_NAME"

if [ -d "devices/$DEVICE_NAME" ]; then

  DEVICE_GROUP=$(cat devices/$DEVICE_NAME/group.txt)
  DEVICE_BOARD=$(cat devices/$DEVICE_NAME/board.txt)
  SERIAL_PORT=$(cat devices/$DEVICE_NAME/port.txt)
  DEVICE_HOST=$(cat devices/$DEVICE_NAME/host.txt)
  
  echo "  Device group: $DEVICE_GROUP"
  echo "  Device board: $DEVICE_BOARD"
  echo "  Device port: $SERIAL_PORT"
  echo ""
  
  echo "  Setting $DEVICE_NAME device is-uploading.txt flag file to 0 (false)..."
  echo "0" > "devices/$DEVICE_NAME/is-uploading.txt"
fi

SUMMARY="$DEVICE_BOARD $DEVICE_GROUP on $SERIAL_PORT"

bash notify-send.sh "Upload failed for $DEVICE_NAME" "$SUMMARY"

bash mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Upload failed" -r || echo "Failed to publish status to MQTT"

bash create-alert-file.sh "$DEVICE_NAME upload failed"

echo "Finished reporting device upload failed."
