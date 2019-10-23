echo ""
echo "Disabling garden device services"
echo ""

DIR=$PWD

DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Error: Please specify a device name as an argument."
else

  echo "Device name: $DEVICE_NAME"

  echo "Disabling MQTT bridge service" && \
  sudo systemctl stop growsense-mqtt-bridge-$DEVICE_NAME.service && \
  sudo systemctl disable growsense-mqtt-bridge-$DEVICE_NAME.service && \

  echo "Disabling Updater bridge service" && \
  sudo systemctl stop growsense-updater-$DEVICE_NAME.service && \
  sudo systemctl disable growsense-updater-$DEVICE_NAME.service && \

  echo "Garden device services disabled for '$DEVICE_NAME'"

fi
