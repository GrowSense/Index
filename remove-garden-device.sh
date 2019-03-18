echo ""
echo "Removing garden device configuration"
echo ""

DEVICE_NAME=$1

SYSTEMCTL_SCRIPT="systemctl.sh"

if [ ! $DEVICE_NAME ]; then
  echo "Error: Specify a device name as an argument."
else
  echo "Device name: $DEVICE_NAME"

  echo "Stopping/disabling MQTT bridge service" && \
  sh $SYSTEMCTL_SCRIPT stop greensense-mqtt-bridge-$DEVICE_NAME.service
  sh $SYSTEMCTL_SCRIPT disable greensense-mqtt-bridge-$DEVICE_NAME.service

  echo "Removing MQTT bridge service" && \
  rm -f scripts/apps/BridgeArduinoSerialToMqttSplitCsv/svc/greensense-mqtt-bridge-$DEVICE_NAME.service

  echo "Stopping/disabling service" && \
  sh $SYSTEMCTL_SCRIPT stop greensense-updater-$DEVICE_NAME.service
  sh $SYSTEMCTL_SCRIPT disable greensense-updater-$DEVICE_NAME.service

  echo "Removing updater service" && \
  rm -f scripts/apps/GitDeployer/svc/greensense-updater-$DEVICE_NAME.service

  echo "Removing device info"
  DEVICE_INFO_DIR="devices/$DEVICE_NAME"
  if [ -d $DEVICE_INFO_DIR ]; then
    rm $DEVICE_INFO_DIR -R
  fi
  
  # Remove from mobile UI
  #  cd mobile/linearmqtt/ && \
  #  sh remove-garden-monitor-ui.sh $DEVICE_NAME && \
  #  cd $DIR

  echo "Garden device removed: $DEVICE_NAME"
fi
