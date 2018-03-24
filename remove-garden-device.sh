echo ""
echo "Removing garden device configuration"
echo ""

DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Error: Specify a device name as an argument."
else
  echo "Device name: $DEVICE_NAME"

  # Remove MQTT bridge service
  echo "Removing MQTT bridge service" && \
  rm -f scripts/apps/BridgeArduinoSerialToMqttSplitCsv/svc/greensense-mqtt-bridge-$DEVICE_NAME.service && \

  # Remove update service
  echo "Removing updater service" && \
  rm -f scripts/apps/GitDeployer/svc/greensense-updater-$DEVICE_NAME.service && \

  echo "Garden device removed: $DEVICE_NAME"
fi
