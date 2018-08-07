echo ""
echo "Restarting garden device services"
echo ""

DIR=$PWD

DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Error: Please specify a device name as an argument."
else

  echo "Device name: $DEVICE_NAME"

  echo "Restart MQTT bridge service" && \
  sudo systemctl restart greensense-mqtt-bridge-$DEVICE_NAME.service && \

  echo "Restart Updater service" && \
  sudo systemctl restart greensense-updater-$DEVICE_NAME.service && \

  echo "Garden device services restarted for '$DEVICE_NAME'"

fi
