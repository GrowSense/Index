DEVICE_NAME=$1

echo "Reporting device is uploading..."

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Uploading" || echo "Failed to publish status to MQTT"

if [ -d "devices/$DEVICE_NAME" ]; then 
  DEVICE_GROUP=$(cat devices/$DEVICE_NAME/group.txt)
  DEVICE_BOARD=$(cat devices/$DEVICE_NAME/board.txt)
  
  echo "  Device group: $DEVICE_GROUP"
  echo "  Device board: $DEVICE_BOARD"
  echo ""
  
  echo "  Setting device is-uploading.txt flag file to 1 (true)..."
  echo "1" > "devices/$DEVICE_NAME/is-uploading.txt"
  
  SUMMARY="$DEVICE_BOARD $DEVICE_GROUP"
fi

sh notify-send.sh "Uploading $DEVICE_NAME" $DEVICE_SUMMARY

echo "Finished reporting device is uploading."
