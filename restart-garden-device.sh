echo ""
echo "Restarting garden device service"
echo ""

DIR=$PWD

DEVICE_NAME=$1

CURRENT_HOST=$(cat /etc/hostname)

if [ ! $DEVICE_NAME ]; then
  echo "Error: Please specify a device name as an argument."
else

  echo "Device name: $DEVICE_NAME"

  DEVICE_GROUP=$(cat "devices/$DEVICE_NAME/group.txt")
  DEVICE_BOARD=$(cat "devices/$DEVICE_NAME/board.txt")
  DEVICE_HOST=$(cat "devices/$DEVICE_NAME/host.txt")

  echo "Device group: $DEVICE_GROUP"
  echo "Device board: $DEVICE_BOARD"
  echo "Device host: $DEVICE_HOST"
  echo "Current host: $CURRENT_HOST"

  if [ "$DEVICE_HOST" != "$CURRENT_HOST" ]; then

    echo "  Device is on another host. Skipping restart service..."

  elif [ "$DEVICE_BOARD" = "esp" ]; then

    echo "  ESP/WiFi device. Skipping restart service..."

  elif [ "$DEVICE_GROUP" = "ui" ]; then

    echo "  Restarting UI controller service" && \
    sh systemctl.sh restart growsense-ui-1602-$DEVICE_NAME.service || exit 1

  else

    echo "  Restarting MQTT bridge service" && \
    sh systemctl.sh restart growsense-mqtt-bridge-$DEVICE_NAME.service || exit 1

  fi

  echo "Garden device services restarted for '$DEVICE_NAME'"
fi

echo ""
echo "Finished restarting garden device service"
echo ""
