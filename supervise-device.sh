LOOP_NUMBER=$1
DEVICE_NAME=$2

EXAMPLE="Example:\n\tsh supervise-device.sh [LoopNumber] [DeviceName]"

echo "Supervising garden device..."

if [ ! $LOOP_NUMBER ]; then
  echo "Please provide a loop number as an argument."
  echo $EXAMPLE
  exit 1
fi

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  echo $EXAMPLE
  exit 1
fi

echo "  Loop number: $LOOP_NUMBER"
echo "  Device name: $DEVICE_NAME"

DEVICE_BOARD=$(cat "devices/$DEVICE_NAME/board.txt")

if [ "$DEVICE_BOARD" = "esp" ]; then
  if [ -f "devices/$DEVICE_NAME/is-uploaded.txt" ]; then
    IS_UPLOADED=$(cat "devices/$DEVICE_NAME/is-uploaded.txt")
  else
    IS_UPLOADED=0
  fi

  if [ "$IS_UPLOADED" = "1" ]; then
    if [ $(( $LOOP_NUMBER%$STATUS_CHECK_FREQUENCY )) -eq "0" ]; then
      sh supervise-device-status.sh $DEVICE_NAME
    fi
  else
    echo "  ESP board sketch hasn't been uploaded. Uploading in background..."
    DEVICE_GROUP=$(cat "devices/$DEVICE_NAME/group.txt")
    DEVICE_PORT=$(cat "devices/$DEVICE_NAME/port.txt")
    
    echo "    Group: $DEVICE_GROUP"
    
    sh run-background.sh sh upload-$DEVICE_GROUP-esp-sketch.sh $DEVICE_NAME $DEVICE_PORT
  fi
else
  if [ $(( $LOOP_NUMBER%$STATUS_CHECK_FREQUENCY )) -eq "0" ]; then
    sh supervise-device-status.sh $DEVICE_NAME
  fi
fi
