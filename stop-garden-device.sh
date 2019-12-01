echo ""
echo "Stopping garden device services"
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
    echo "  ESP/WiFi device. No services need to be stopped."
  else
    if [ "$DEVICE_GROUP" = "ui" ]; then
    
      echo "  Stopping UI controller service"
      if [ -f "/lib/systemd/system/growsense-ui-1602-$DEVICE_NAME.service" ]; then
        sh systemctl.sh stop growsense-ui-1602-$DEVICE_NAME.service || exit 1
      fi
    else
      echo "  Stopping MQTT bridge service"
      if [ -f "/lib/systemd/system/growsense-mqtt-bridge-$DEVICE_NAME.service" ]; then
        sh systemctl.sh stop growsense-mqtt-bridge-$DEVICE_NAME.service || exit 1
      fi
    fi
    
    echo "Garden device services stopped for '$DEVICE_NAME'"
  fi
fi
