DEVICE_NAME=$1
DEVICE_BOARD=$2
DEVICE_GROUP=$3
SERIAL_PORT=$4

echo "Reporting device is uploading..."

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Uploading" || echo "Failed to publish status to MQTT"

if [ -d "devices/$DEVICE_NAME" ]; then 
  DEVICE_GROUP=$(cat devices/$DEVICE_NAME/group.txt)
  DEVICE_BOARD=$(cat devices/$DEVICE_NAME/board.txt)
  SERIAL_PORT=$(cat devices/$DEVICE_NAME/port.txt)
  
  echo "  Device group: $DEVICE_GROUP"
  echo "  Device board: $DEVICE_BOARD"
  echo ""
  
  echo "  Setting device is-uploading.txt flag file to 1 (true)..."
  echo "1" > "devices/$DEVICE_NAME/is-uploading.txt"
fi

SUMMARY="$DEVICE_BOARD $DEVICE_GROUP on $SERIAL_PORT"

sh notify-send.sh "Uploading $DEVICE_NAME" "$SUMMARY"

echo "Finished reporting device is uploading."
