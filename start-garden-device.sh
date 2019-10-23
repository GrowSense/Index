echo ""
echo "Starting garden device services"
echo ""

DIR=$PWD

DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Error: Please specify a device name as an argument."
else
  echo "Device name: $DEVICE_NAME"
  
  DEVICE_GROUP=$(cat "devices/$DEVICE_NAME/group.txt")
  DEVICE_BOARD=$(cat "devices/$DEVICE_NAME/board.txt")
  
  echo "  Device group: $DEVICE_GROUP"
  echo "  Device board: $DEVICE_BOARD"
  
  
  if [ "$DEVICE_BOARD" = "esp" ]; then
    echo "  WiFi/ESP device. No need to start services."
  else
    if [ "$DEVICE_GROUP" = "ui" ]; then
      echo "  Starting UI controller service..." && \
      sh systemctl.sh start growsense-ui-1602-$DEVICE_NAME.service || exit 1
    else
      echo "  Starting MQTT bridge service..." && \
      sh systemctl.sh start growsense-mqtt-bridge-$DEVICE_NAME.service || exit 1
    fi
    echo "Garden device services started for '$DEVICE_NAME'"
  fi  
fi
