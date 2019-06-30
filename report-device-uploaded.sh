DEVICE_NAME=$1

echo "Reporting device uploaded..."

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

echo "  Device name: $DEVICE_NAME"

SUMMARY=""

if [ -d "devices/$DEVICE_NAME" ]; then
  DEVICE_GROUP=$(cat devices/$DEVICE_NAME/group.txt)
  DEVICE_BOARD=$(cat devices/$DEVICE_NAME/board.txt)
  
  echo "  Device group: $DEVICE_GROUP"
  echo "  Device board: $DEVICE_BOARD"
  echo ""
  
  echo "  Setting device is-uploading.txt flag file to 0 (false)..."
  echo "0" > "devices/$DEVICE_NAME/is-uploading.txt"
fi
 
sh notify-send.sh "Uploaded $DEVICE_NAME" "$SUMMARY"

sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Uploaded" || echo "Failed to publish status to MQTT"

echo "Finished notifying device uploaded."
