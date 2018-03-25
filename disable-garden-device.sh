echo ""
echo "Disabling garden device"
echo ""

DIR=$PWD

DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Error: Please specify a device name as an argument."
else

  echo "Device name: $DEVICE_NAME"

  # Set up MQTT bridge service
  echo "Disabling MQTT bridge service" && \
  systemctl stop greensense-mqtt-bridge-$DEVICE_NAME.service && \
  systemctl disable greensense-mqtt-bridge-$DEVICE_NAME.service && \

  echo "Disabling Updater bridge service" && \
  systemctl stop greensense-updater-$DEVICE_NAME.service && \
  systemctl disable greensense-updater-$DEVICE_NAME.service && \

  echo "Garden device services disabled for '$DEVICE_NAME'"

fi
