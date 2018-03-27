echo ""
echo "Removing garden device configuration"
echo ""

DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Error: Specify a device name as an argument."
else
  echo "Device name: $DEVICE_NAME"

  echo "Disabling MQTT bridge service" && \
  sudo systemctl disable greensense-mqtt-bridge-$DEVICE_NAME.service && \

  echo "Removing MQTT bridge service" && \
  rm -f scripts/apps/BridgeArduinoSerialToMqttSplitCsv/svc/greensense-mqtt-bridge-$DEVICE_NAME.service && \

  echo "Disabling updater service" && \
  sudo systemctl disable greensense-updater-$DEVICE_NAME.service && \

  echo "Removing updater service" && \
  rm -f scripts/apps/GitDeployer/svc/greensense-updater-$DEVICE_NAME.service && \

  # Remove up mobile UI
#  cd mobile/linearmqtt/ && \
#  sh remove-garden-monitor-ui.sh $DEVICE_NAME && \
#  cd $DIR

  echo "Garden device removed: $DEVICE_NAME"
fi
